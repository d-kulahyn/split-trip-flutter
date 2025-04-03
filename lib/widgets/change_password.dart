import 'package:flutter/material.dart';
import 'package:split_trip/widgets/forms/elements/input_password_form_element.dart';

import '../constants/theme_constants.dart';

class ChangePassword extends StatelessWidget {

  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  final Map<String, dynamic>? additional;
  
  const ChangePassword({super.key, required this.formData, required this.errors, this.additional});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      children: [
        Container(
          constraints: const BoxConstraints(
            minHeight: cTextFormFieldHeight,
          ),
          child: PasswordInput(
            name: 'old_password',
            formData: formData,
            hint: 'Password',
            errorText: errors['old_password'] ?? '',
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            minHeight: cTextFormFieldHeight,
          ),
          child: PasswordInput(
            name: 'new_password',
            formData: formData,
            hint: 'Password',
            errorText: errors['new_password'] ?? '',
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            minHeight: cTextFormFieldHeight,
          ),
          child: PasswordInput(
            name: 'confirm_password',
            formData: formData,
            hint: 'Password',
            errorText: errors['confirm_password'] ?? '',
          ),
        )
      ],
    );
  }
}

