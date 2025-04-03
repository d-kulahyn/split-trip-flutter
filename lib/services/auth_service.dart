import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/models/user_model.dart';
import 'package:split_trip/repositories/auth_repository.dart';

import '../models/auth_model.dart';
import '../screens/login_screen.dart';
import 'access_token_storage_manager.dart';

class AuthService {
  final BuildContext context;
  final AuthRepository authRepository;
  final AccessTokenStorageManager accessTokenStorageManager;

  AuthService({
    required this.context,
    required this.authRepository,
    required this.accessTokenStorageManager,
  });

  Future<void> login(Map<String, dynamic> data) async {
    final String accessToken = data['access_token'];
    final Map<String, dynamic> userData = data['user'];
    final authModel = context.read<AuthModel>();

    await accessTokenStorageManager.setTokenToStorage(accessToken);

    final authUser = UserModel.fromJson(userData);

    authModel.setUser(authUser);
  }

  void logout(BuildContext context) {
    accessTokenStorageManager.removeTokenFromStorage();
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }

  Future<void> refreshUser() async {
    final authModel = context.read<AuthModel>();
    final response = await authRepository.userMe();
    final authUser = UserModel.fromJson(jsonDecode(response.body));
    authModel.setUser(authUser);
  }
}
