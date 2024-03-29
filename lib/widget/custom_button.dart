

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   CustomButton({
    super.key,
    required this.title,
    required this.onTap
  });
  String title;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: TextButton(style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ))
      ),onPressed: onTap, child: Text(title)),
    );
  }
}
