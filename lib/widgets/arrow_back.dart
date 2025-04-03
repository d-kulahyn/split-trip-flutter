import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  final Function? backCallback;
  final bool transparent;

  const ArrowBack({super.key, this.backCallback, this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { backCallback != null ? backCallback!() : Navigator.pop(context); },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: transparent ? Colors.transparent : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromRGBO(207, 211, 232, 1),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 12,
          ),
        ),
      ),
    );
  }
}
