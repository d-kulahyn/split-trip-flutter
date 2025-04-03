import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:split_trip/enums/social_provider_enums.dart';
import 'package:split_trip/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/services/request_service.dart';

import '../../constants/theme_constants.dart';
import '../../services/auth_service.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

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
      final AuthRepository authRepository = Provider.of<AuthRepository>(context, listen: false);
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: cSizeSocialButton,
            height: cSizeSocialButton,
            child: IconButton(
              onPressed: () {
                handleGoogleSignIn(context);
              },
              icon: SvgPicture.asset('assets/images/google.svg'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: cSizeSocialButton,
            height: cSizeSocialButton,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/images/facebook.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
