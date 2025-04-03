import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/constants/app_constants.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/screens/login_screen.dart';
import 'package:split_trip/widgets/auth_elements/social_buttons.dart';
import 'package:split_trip/constants/theme_constants.dart';
import 'package:split_trip/widgets/forms/auth/register_form.dart';

import '../providers/loader_provider.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';
import '../services/request_service.dart';
import '../widgets/theme_components/button.dart';
import '../widgets/theme_components/loader.dart';
import 'annotated_region.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {

  Map<String, dynamic> formData = {};

  final ValueNotifier<Map<String, dynamic>> errorsNotifier = ValueNotifier({});

  Map<String, dynamic> errors = {};

  void signUp(BuildContext context) async {
    final authRepository = context.read<AuthRepository>();

    RequestService.send(context, authRepository.register(formData), onSuccess: (Map<String, dynamic> data) async {
      final AuthService authService = context.read<AuthService>();

      await authService.login(data);

      Navigator.pushNamedAndRemoveUntil(context, GroupListScreen.routeName, (r) => false);
    }, errorsNotifier: errorsNotifier);
  }

  @override
  void initState() {
    super.initState();
    errorsNotifier.addListener(() => setState(() {
      errors = errorsNotifier.value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom + 20
                ),
                child: Column(
                  children: [
                    Container(
                      padding: cAuthScreenPaddings,
                      child: Column(
                        children: [
                          const Text('Create an Account', style: cAuthScreenSubTitleStyles),
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            child: RegisterForm(formData: formData, errors: errors),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color.fromRGBO(99, 104, 116, 1),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      signUp(context);
                    },
                    child: const Button(text: 'Sign up'),
                  ),
                ],
              ),
            ),
            Consumer<LoaderProvider>(
              builder: (context, loader, child) => Visibility(
                visible: loader.show,
                child: Center(
                  child: screenLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
