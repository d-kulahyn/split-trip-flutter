import 'package:flutter/material.dart';
import 'package:split_trip/widgets/forms/elements/input_password_form_element.dart';
import 'package:split_trip/widgets/forms/elements/input_text_form_element.dart';

class RegisterForm extends StatefulWidget {

  final Map<String, dynamic> formData;
  final Map<String, dynamic>? errors;
  final bool? create;

  const RegisterForm({super.key, required this.formData, this.errors, this.create});

  @override
  State<RegisterForm> createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: <Widget>[
        TextFormInput(
          name: 'email',
          formData: widget.formData,
          hintText: 'Email',
          errorText: widget.errors?['email'],
          initialValue: 'liuda@gmail.com',
        ),
        PasswordInput(
          name: 'password',
          formData: widget.formData,
          hint: 'Password',
          errorText: widget.errors?['password'],
          initialValue: 'qwerty123',
        ),
        PasswordInput(
          name: 'confirm_password',
          formData: widget.formData,
          hint: 'Confirm Password',
          errorText: widget.errors?['confirm_password'],
          initialValue: 'qwerty123',
        ),
      ],
    );
  }
}
