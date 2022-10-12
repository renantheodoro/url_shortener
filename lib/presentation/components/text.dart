import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  const TextBold({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) => Text(
        text ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      );
}
