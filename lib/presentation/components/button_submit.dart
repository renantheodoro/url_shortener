import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  const ButtonSubmit({Key? key, required this.callback}) : super(key: key);

  final Function callback;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.purpleAccent,
            onTap: () => callback(),
            child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ),
        ),
      );
}
