import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import 'forms/elements/input_text_form_element.dart';

class ChangeEmail extends StatelessWidget {

  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  final Map<String, dynamic>? additional;
  
  const ChangeEmail({super.key, required this.formData, required this.errors, this.additional});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: cTextFormFieldHeight,
      ),
      child: TextFormInput(
        name: 'email',
        formData: formData,
        hintText: 'Email',
        initialValue: formData['email'],
        errorText: errors['email'] ?? '',
      ),
    );
  }
}

