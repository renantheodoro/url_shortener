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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.grey, // Cor da label
        ),
        hintText: widget.label, // Dica se o campo estiver vazio
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.purple), // Cor da borda quando em foco
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5)), // Cor da borda desabilitada
        ),
        errorBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.red), // Cor da borda se houver erro
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors
                  .red), // Cor da borda se o campo estiver em erro e focado
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0, horizontal: 12.0), // Padding interno
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorInputText;
        }
        return null;
      },
    );
  }
}
