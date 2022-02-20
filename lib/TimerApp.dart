// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

class Timer2 extends StatefulWidget {
  const Timer2({Key? key}) : super(key: key);

  @override
  _Timer2State createState() => _Timer2State();
}

class _Timer2State extends State<Timer2> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void startTimer({bool reset = true}) {
    // Also want to reset when seconds reaches 0. So seconds -- wont work.
    if (reset) {
      resetTimer();
    }

    // Initilize timer
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      // so that seconds doesnt go bellow 0. Stop if it does.
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        // Reset false bcoz we dont want to reset when seconds naturally reaches 0
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    // Reset the timer when cancel is called.
    if (reset) {
      resetTimer();
    }
    // Pauses the Timer
    setState(() {
      timer?.cancel();
    });
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTimer(),
            SizedBox(height: 80),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    // When reached the end of timer, show again start timer button.
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning ||
            !isCompleted // not completed show this. Compleated show other one.
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: isRunning ? 'Pause' : 'Resume',
                  onClicked: () {
                    if (isRunning) {
                      //Paused
                      // so that pause doesnt reset the clock.
                      stopTimer(reset: false);
                    } else {
                      // in Resume button
                      startTimer(reset: false);
                    }
                  }),
              SizedBox(width: 12),
              ButtonWidget(text: 'Cancel', onClicked: stopTimer)
            ],
          )
        : ButtonWidget(
            text: 'Start Timer',
            onClicked: () {
              startTimer();
            },
            color: Colors.black,
            backgroundColor: Colors.white,
          );
  }

  Widget buildTimer() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          value: -seconds / maxSeconds,
          strokeWidth: 12,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          backgroundColor: Colors.greenAccent,
        ),
        Center(
          child: buildTime(),
        ),
      ]),
    );
  }

  Widget buildTime() {
    // if seconds is 0, show done.
    if (seconds == 0) {
      return Icon(Icons.done, color: Colors.greenAccent, size: 112);
    } else {
      return Text(
        '$seconds',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 80),
      );
    }
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final Color backgroundColor;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.color = Colors.white,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: color),
        ));
  }
}
