import 'dart:async';

import 'package:equb/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class FourtuinWheel extends StatefulWidget {
  const FourtuinWheel({Key? key}) : super(key: key);

  @override
  State<FourtuinWheel> createState() => _FourtuinWheelState();
}

class _FourtuinWheelState extends State<FourtuinWheel> {
  // StreamController<int> controller = StreamController.broadcast();
  final controller = BehaviorSubject<int>();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  String reward = '';
  @override
  Widget build(BuildContext context) {
    final items = <String>['Nahom', 'Dawit', 'eyuel', 'fikr', 'yoda'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Spin the Wheel'),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Expanded(
                child: FortuneWheel(
                  onFling: () {
                    controller.add(1);
                  },
                  onAnimationStart: () {
                    print('helloTHre');
                  },
                  onAnimationEnd: () {
                    setState(() {
                      reward = items[controller.stream.value];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                          content: CustomSnackBar(
                              message: 'The Winner is $reward',
                              isSuccess: true,
                              duration:Duration(seconds:6),)));
                    });
                  },
                  animateFirst: false,
                  physics: CircularPanPhysics(
                    duration: Duration(seconds: 2),
                    curve: Curves.decelerate,
                  ),
                  selected: controller.stream,
                  items: [
                    for (var it in items) FortuneItem(child: Text(it)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    controller.add(Fortune.randomInt(0, items.length));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Theme.of(context).primaryColor ,
                  foregroundColor:Theme.of(context).textTheme.headline1!.color,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Spin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
