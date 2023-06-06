import 'package:flutter/material.dart';

class EtaDetail extends StatefulWidget {
  const EtaDetail({super.key});

  @override
  State<EtaDetail> createState() => _EtaDetailState();
}

class _EtaDetailState extends State<EtaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('You are Not Allowed to spin the wheel ',style:TextStyle(color:Colors.red[400]),)),
    );
  }
}
