import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key, required this.hintText, required this.options});
  final String hintText;
  final List<String> options;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late String _selectedOption;
  bool _isFocused = false;
  
  @override
  void initState() {
    _selectedOption = widget.options[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      decoration: InputDecoration(
        focusColor: Theme.of(context).primaryColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        hintText: widget.hintText,
        prefix: SizedBox(
          width: 100,
          child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor: Theme.of(context).primaryColor,
              ),
              focusColor: Theme.of(context).primaryColor,
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              autofocus: true,
              borderRadius: BorderRadius.circular(20),
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color),
              value: _selectedOption,
              items:
                  widget.options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue!;
                });
              }),
        ),
      ),
    );
  }
}
