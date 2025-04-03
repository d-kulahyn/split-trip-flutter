import 'package:flutter/material.dart';
import 'package:split_trip/screens/login_screen.dart';
import 'package:split_trip/services/access_token_storage_manager.dart';

class LogoutScreen extends StatefulWidget {
  static const String routeName = 'logoutScreen';

  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => LogoutScreenState();
}

class LogoutScreenState extends State<LogoutScreen> {
  void logout() {
    final AccessTokenStorageManager accessTokenStorage = AccessTokenStorageManager();
    accessTokenStorage.removeTokenFromStorage();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: logout,
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
