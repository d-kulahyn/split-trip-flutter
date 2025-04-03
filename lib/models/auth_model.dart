import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:split_trip/models/user_model.dart';
import 'package:split_trip/repositories/auth_repository.dart';

class AuthModel extends ChangeNotifier {
  UserModel? _user;
  static String? firebaseCloudMessagingToken;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> loadUser() async {
    final AuthRepository authRepository = AuthRepository();

    final Response response = await authRepository.userMe();

    if (response.statusCode != HttpStatus.ok) {

      return false;
    }

    final Map<String, dynamic> user = jsonDecode(response.body);

    setUser(UserModel.fromJson(user));

    return true;
  }

  void clearUser() {
    _user = null;
  }
}
