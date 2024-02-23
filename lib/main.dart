import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timerTop;
  late Timer _timerBottom;
  int _secondsRemainingTop = 10 * 60;
  int _secondsRemainingBottom = 10 * 60;
  bool _isTimerRunningTop = false;
  bool _isTimerRunningBottom = false;
  int _totalTime = 10*60 ;
  bool _isPaused = false;
  Widget buildProgressBar(int totalTime, int secondsRemaining) {
    double progress = secondsRemaining / totalTime;
    return SingleChildScrollView(
      child: Container(
          height: 10,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
      ),
      child: FractionallySizedBox(
      widthFactor: progress,
      alignment: Alignment.centerLeft,
      child: Container(
      decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(5),
      ),
      ),
      ),
      ),
    );
  }


  void _toggleTimerTop() {
    setState(() {
      if (_isTimerRunningTop || _isPaused) {
        _timerTop.cancel();
      } else {
        _timerTop = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_secondsRemainingTop > 0) {
              _secondsRemainingTop--;
            } else {
              _timerTop.cancel();
            }
          });
        });
      }
      _isTimerRunningTop = !_isTimerRunningTop;
      _isPaused = false;

      if (_isTimerRunningTop) {
        _timerBottom.cancel();
        _isTimerRunningBottom = false;
      } else {
        _timerBottom = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_secondsRemainingBottom > 0) {
              _secondsRemainingBottom--;
            } else {
              _timerBottom.cancel();
            }
          });
        });
        _isTimerRunningBottom = true;
      }
    });
  }

  void _toggleTimerBottom() {
    setState(() {
      if (_isTimerRunningBottom || _isPaused) {
        _timerBottom.cancel();
      } else {
        _timerBottom = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_secondsRemainingBottom > 0) {
              _secondsRemainingBottom--;
            } else {
              _timerBottom.cancel();
            }
          });
        });
      }
      _isTimerRunningBottom = !_isTimerRunningBottom;
      _isPaused = false;

      if (_isTimerRunningBottom) {
        _timerTop.cancel();
        _isTimerRunningTop = false;
      } else {
        _timerTop = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_secondsRemainingTop > 0) {
              _secondsRemainingTop--;
            } else {
              _timerTop.cancel();
            }
          });
        });
        _isTimerRunningTop = true;
      }
    });
  }

  void _showTimeSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionner le temps'),
          content: Column(
            children: [
              ListTile(
                title: Text('5 minutes'),
                onTap: () {
                  _setTime(5 * 60);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('10 minutes'),
                onTap: () {
                  _setTime(10 * 60);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('15 minutes'),
                onTap: () {
                  _setTime(15 * 60);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('20 minutes'),
                onTap: () {
                  _setTime(20 * 60);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('30 minutes'),
                onTap: () {
                  _setTime(30 * 60);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTime(int seconds) {
    setState(() {
      _totalTime = seconds;
      _secondsRemainingTop = seconds;
      _secondsRemainingBottom = seconds;
    });
  }

  void _resetTimers() {
    setState(() {
      _secondsRemainingTop = _totalTime;
      _isTimerRunningTop = false;
      _timerTop.cancel();

      _secondsRemainingBottom = _totalTime;
      _isTimerRunningBottom = false;
      _timerBottom.cancel();
    });
  }
  @override
  void initState() {
    super.initState();
    _timerTop = Timer(Duration.zero, () {});
    _timerBottom = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _timerTop.cancel();
    _timerBottom.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _toggleTimerTop();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: _isTimerRunningTop ? Colors.blueGrey : Colors.grey,
                ),
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(3.15),
                    child: Text(
                      formatTime(_secondsRemainingTop),
                      style: TextStyle(
                        fontSize: 80.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.access_alarm),
                  onPressed: () {
                    _showTimeSelectionDialog();
                  },
                ),
                // Remplacez cette ligne par le code du IconButton de pause
                IconButton(
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  onPressed: () {
                    setState(() {
                      _isPaused = !_isPaused;
                      if (_isPaused) {
                        _timerTop.cancel();
                        _timerBottom.cancel();
                      }
                    });
                  },
                ),

                IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () {
                    _resetTimers();
                  },
                ),
                Text(
                  'Go',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: () {
                _toggleTimerBottom();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: _isTimerRunningBottom ? Colors.blueGrey : Colors.grey,
                ),
                child: Center(
                  child: Text(
                    formatTime(_secondsRemainingBottom),
                    style: TextStyle(
                      fontSize: 80.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }
}
