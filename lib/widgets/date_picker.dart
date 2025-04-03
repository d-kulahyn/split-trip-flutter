import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/theme_constants.dart';

class DatePicker extends StatefulWidget {
  final Function? callback;

  const DatePicker({super.key, this.callback});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month - 6, now.day);
    final DateTime lastDate = DateTime(now.year, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        if (widget.callback != null) {
          widget.callback!(pickedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: cBorderInactiveColor,
          ),
          borderRadius: cInputBorderRadius,
        ),
        child: GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Center(
            child: Text(
              style: const TextStyle(color: Colors.indigo),
              DateFormat('d MMM. y').format(selectedDate),
            ),
          ),
        ),
      ),
    );
  }
}
