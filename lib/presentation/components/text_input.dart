import 'package:flutter/material.dart';
import 'package:url_shortener/core/consts/error_input_text.const.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key, this.controller, this.label}) : super(key: key);

  final TextEditingController? controller;
  final String? label;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorInputText;
          }
          return null;
        },
      );
}