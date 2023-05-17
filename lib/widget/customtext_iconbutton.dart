import 'package:flutter/material.dart';

class CustomTextButtonIcon extends StatelessWidget {
  CustomTextButtonIcon({
    required this.icon,
    required this.color,
    required this.text,
    required this.ontap,
    Key? key,
  }) : super(key: key);

  IconData icon;
  Color color;
  String text;
  Function() ontap;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          foregroundColor: MaterialStateProperty.all(color),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14),
          ),
        ),
        label: Text(text),
        onPressed:ontap ,
        icon: Icon(
          icon,
          size: 14,
        ));
  }
}
