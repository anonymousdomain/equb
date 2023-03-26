import 'package:flutter/material.dart';

class CustomLoadingButton extends StatefulWidget {
  const CustomLoadingButton({super.key});

  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          onPressed: () {},
          child: CircleAvatar(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
