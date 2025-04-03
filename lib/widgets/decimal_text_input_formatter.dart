import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text;

    if (text.startsWith("00")) {
      text = text.replaceFirst(RegExp(r'^0+'), '0');
    } else if (text.startsWith("0") && text.length > 1 && text[1] != '.') {
      text = text.substring(1);
    }

    final regex = RegExp(r'^\d+(\.\d{0,' + decimalRange.toString() + r'})?$');

    if (regex.hasMatch(text)) {
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    return oldValue;
  }
}
