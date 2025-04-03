import 'package:flutter/material.dart';

import '../../../constants/theme_constants.dart';
import '../elements/input_password_form_element.dart';
import '../elements/input_text_form_element.dart';

class LoginFormNew extends StatelessWidget {

  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  
  const LoginFormNew({super.key, required this.formData, required this.errors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        SizedBox(
          height: cTextFormFieldGeneralHeight,
          child: TextFormInput(
            name: 'email',
            formData: formData,
            hintText: 'Email',
            errorText: errors['email'],
            initialValue: 'liuda@gmail.com',
          ),
        ),
        SizedBox(
          height: cTextFormFieldGeneralHeight,
          child: PasswordInput(
            name: 'password',
            formData: formData,
            hint: 'Password',
            errorText: errors['password'] ?? '',
            initialValue: 'qwerty123',
          ),
        ),
      ],
    );
  }
}

