import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({this.key, this.text, this.height, this.onPressed}) : super(key: key);
  Key? key;
  String? text;
  double? height;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: height),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text!, style: TextStyle(color: Colors.white, fontSize: 20.0))),
    );
  }
}