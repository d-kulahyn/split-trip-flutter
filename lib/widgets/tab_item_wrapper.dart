import 'package:flutter/material.dart';

class TabItemWrapper extends StatelessWidget {
  final Widget body;

  const TabItemWrapper({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
      width: MediaQuery.of(context).size.width - 10,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(175, 175, 224, 0.15),
            offset: Offset(0, 0),
            blurRadius: 21.1,
          ),
        ],
      ),
      child: body,
    );
  }
}
