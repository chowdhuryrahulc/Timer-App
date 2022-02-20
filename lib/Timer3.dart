// Increment
// Decrement
// Pause, Resume only

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_app/TimerApp.dart';

class Timer3 extends StatefulWidget {
  const Timer3({Key? key}) : super(key: key);

  @override
  _Timer3State createState() => _Timer3State();
}

class _Timer3State extends State<Timer3> {
  int seconds = 60;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      // so that seconds doesnt reduce below 0. Stop when it does.
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget buildTimer() {
    return Center(
      child: buildTime(),
    );
  }

  Widget buildTime() {
    return Text(
      '$seconds',
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 80),
    );
  }

  Widget buildButton() {
    final isRunning = timer == null ? false : timer!.isActive;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
            text: 'decrement',
            onClicked: () {
              if (seconds > 0) {
                setState(() {
                  seconds--;
                });
              }
            }),
        ButtonWidget(
            text: isRunning ? 'Pause' : 'Resume',
            onClicked: () {
              if (isRunning) {
                stopTimer();
              } else {
                startTimer();
              }
            }),
        ButtonWidget(
            text: 'increment',
            onClicked: () {
              if (seconds < 60) {
                setState(() {
                  seconds++;
                });
              }
            }),
      ],
    );
  }
}
