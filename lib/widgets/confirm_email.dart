import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/repositories/auth_repository.dart';
import 'package:split_trip/services/request_service.dart';
import 'package:split_trip/utilities/animated_text.dart';
import 'package:split_trip/widgets/forms/elements/otp_input_form_element.dart';

class ConfirmEmail extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  final Map<String, dynamic>? additional;

  const ConfirmEmail({super.key, required this.formData, required this.errors, this.additional});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  Timer? timer;

  int secondsRemaining = 0;
  bool isButtonDisabled = false;

  void startTimer() {
    setState(() {
      secondsRemaining = 3;
      isButtonDisabled = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isButtonDisabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            OTPInput(
              length: 6,
              onCompleted: (String value) async {
                widget.formData['code'] = value;
              },
            ),
            AnimatedText(
              text: widget.errors['code'] ?? '',
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            TextButton(
              onPressed: isButtonDisabled
                  ? null
                  : () {
                      startTimer();
                      final AuthRepository authRepository = context.read<AuthRepository>();
                      RequestService.send(context, authRepository.sendConfirmationCode());
                      // Send code
                    },
              child: const Text("Send code again"),
            ),
            Visibility(
              visible: isButtonDisabled,
              child: Text(
                "Retry in $secondsRemaining sec",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          ],
        ),
      ],
    );
  }
}
