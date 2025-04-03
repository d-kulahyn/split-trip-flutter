import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import 'forms/elements/input_text_form_element.dart';

class EditProfile extends StatelessWidget {

  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  final Map<String, dynamic>? additional;
  
  const EditProfile({super.key, required this.formData, required this.errors, this.additional});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: cTextFormFieldHeight,
      ),
      child: TextFormInput(
        name: 'name',
        formData: formData,
        hintText: 'Name',
        initialValue: formData['name'],
        errorText: errors['name'] ?? '',
      ),
    );
  }
}

