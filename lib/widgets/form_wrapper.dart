import 'package:flutter/material.dart';

typedef FormConstructor = Widget Function({
  required Map<String, dynamic> formData,
  required Map<String, dynamic> errors,
  Map<String, dynamic>? additional,
});

class FormWrapper<T extends Widget> extends StatefulWidget {
  final FormConstructor body;
  final Map<String, dynamic> formData;
  final Map<String, dynamic>? additional;
  final ValueNotifier<Map<String, dynamic>> errorsNotifier;

  const FormWrapper({super.key, required this.formData, required this.errorsNotifier, required this.body, this.additional});

  @override
  State<FormWrapper> createState() => FormWrapperState();
}

class FormWrapperState extends State<FormWrapper> {
  Map<String, dynamic> errors = {};

  @override
  void initState() {
    super.initState();
    widget.errorsNotifier.addListener(() {
      setState(() {
        errors = widget.errorsNotifier.value;
      });
    });
  }

  @override
  void dispose() {
    widget.errorsNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.body(formData: widget.formData, errors: errors, additional: widget.additional);
  }
}
