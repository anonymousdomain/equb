import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

// class FourtuinApp extends StatelessWidget {
//   const FourtuinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'fortune',
//       home:FourtuinWheel(),
//     );
//   }
// }

class FourtuinWheel extends StatefulWidget {
  const FourtuinWheel({super.key});

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
      body: GestureDetector(
        onTap: () {
          setState(() {
            selected.add(Fortune.randomItem(items as Iterable<int>));
          });
        },
        child: Column(
          children: [
            Expanded(
                child: FortuneWheel(
                    physics: CircularPanPhysics(
                        duration: Duration(seconds: 1),
                        curve: Curves.decelerate),
                    onFling: () {
                      selected.add(1);
                    },
                    selected: selected.stream,
                    items: [
                  for (var it in items) FortuneItem(child: Text(it))
                ]))
          ],
        ),
      ),
    );
  }
}
