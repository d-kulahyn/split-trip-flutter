import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/screens/register_screen.dart';
import 'package:split_trip/widgets/theme_components/button.dart';

import '../constants/theme_constants.dart';
import '../enums/social_provider_enums.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';
import '../services/firebase_api.dart';
import '../services/request_service.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = 'mainScreen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  void goToRegisterScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.routeName, (r) => false);
  }

  Future<void> goToLoginScreen(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
    try {
      final GoogleSignInAccount? accountData = await googleSignIn.signIn();
      if (accountData == null) {
        // User cancel
        return;
      }
      final GoogleSignInAuthentication auth = await accountData.authentication;
      final AuthRepository authRepository = context.read()<AuthRepository>();
      RequestService.send(context, authRepository.socialSignIn(auth.accessToken!, SocialProviderEnums.google), onSuccess: (Map<String, dynamic> data) async {
        final AuthService authService = context.read<AuthService>();
        await authService.login(data['access_token']);

        Navigator.pushNamedAndRemoveUntil(context, GroupListScreen.routeName, (r) => false);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseApi().initNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 46),
                  width: cSizeSocialButton,
                  height: cSizeSocialButton,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const Text(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            height: 1.0,
                            letterSpacing: 0.0,
                          ),
                          textAlign: TextAlign.center,
                          'Manage your \n regular expenses'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'Real-time messaging',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Color.fromRGBO(99, 104, 116, 1),
                        ),
                      ),
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 1.65,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/main_people.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Wrap(
                    runSpacing: 10,
                    children: [
                      const Button(
                        iconPath: 'assets/images/apple_icon.svg',
                        text: 'Continue with Apple',
                      ),
                      GestureDetector(
                        onTap: () {
                          handleGoogleSignIn(context);
                        },
                        child: const Button(
                          iconPath: 'assets/images/google_icon.svg',
                          text: 'Continue with Google',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          goToLoginScreen(context);
                        },
                        child: const Button(
                          text: 'Continue with Email',
                          background: Color.fromRGBO(240, 244, 255, 1),
                          textColor: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color.fromRGBO(99, 104, 116, 1),
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'By pressing on “Continue with...” you are agree to our \n'),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Tapped Privacy Policy');
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Tapped Terms and Conditions');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
