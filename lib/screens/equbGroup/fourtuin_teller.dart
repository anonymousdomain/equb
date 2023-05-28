import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FourtuinWheel extends StatefulWidget {
  const FourtuinWheel({Key? key}) : super(key: key);

  @override
  State<FourtuinWheel> createState() => _FourtuinWheelState();
}

class _FourtuinWheelState extends State<FourtuinWheel> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <String>['Nahom', 'Dawit', 'eyuel', 'fikr', 'yoda'];
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Expanded(
                child: FortuneWheel(
                  animateFirst: false,
                  physics: CircularPanPhysics(
                    duration: Duration(seconds: 1),
                    curve: Curves.decelerate,
                  ),
                  selected: selected.stream,
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
                    selected.add(Fortune.randomInt(0, items.length));
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(8),
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
