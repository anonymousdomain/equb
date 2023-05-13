import 'package:flutter/material.dart';

class CustomTextButtonIcon extends StatelessWidget {
  CustomTextButtonIcon({
    required this.icon,
    required this.color,
    required this.text,
    Key? key,
  }) : super(key: key);

  IconData icon;
  Color color;
  String text;
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
        label: Text('cancel'),
        onPressed: () {},
        icon: Icon(
          icon,
          size: 14,
        ));
  }
}
