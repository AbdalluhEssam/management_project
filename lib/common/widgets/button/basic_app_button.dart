import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? elevation;

  const BasicAppButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color,
      this.textColor, this.elevation});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 50),
          backgroundColor: color,
          elevation: elevation,

        ),
        onPressed: onPressed,
        child: Text(text,style: TextStyle(color: textColor),));
  }
}
