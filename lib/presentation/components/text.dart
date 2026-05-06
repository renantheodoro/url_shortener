import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  const TextBold({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
        color: Colors.purple.shade700,
        letterSpacing: 1.2,
        fontFamily: 'Roboto',
      ),
      textAlign: TextAlign.left,
    );
  }
}
