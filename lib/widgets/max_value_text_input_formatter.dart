import 'package:flutter/services.dart';

class MaxValueTextInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxValueTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    final double? value = double.tryParse(newValue.text);
    if (value != null && value > maxValue) {

      return oldValue;
    }

    return newValue;
  }
}
