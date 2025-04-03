import 'package:flutter/material.dart';

Future<T?> modalBottomSheet<T>(BuildContext context, Widget modal) async {
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: modal,
      );
    },
  );
}