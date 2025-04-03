import 'package:flutter/material.dart';

class SubmitAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SubmitAuthButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 19),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment(-1, -1),
              end: Alignment(1, 1),
              colors: [
                Color.fromRGBO(0, 160, 185, 1),
                Color.fromRGBO(62, 178, 146, 1)
              ])),
      child: TextButton(
        onPressed: () async {
          onPressed();
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
