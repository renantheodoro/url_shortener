import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  const ButtonSubmit({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Material(
        color: Colors.purple,
        child: InkWell(
          onTap: () => callback(),
          child: Container(
            width: 40.0,
            height: 40.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
