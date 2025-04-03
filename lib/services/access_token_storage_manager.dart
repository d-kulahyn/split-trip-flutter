import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:split_trip/constants/constants.dart';

class AccessTokenStorageManager {
  final FlutterSecureStorage secureStorage;

  AccessTokenStorageManager(): secureStorage = const FlutterSecureStorage();

  Future<String?> getTokenFromStorage() async {
    return secureStorage.read(key: accessTokenStorageKey);

  }

  Future<void> setTokenToStorage(String? value) async {
    await secureStorage.write(key: accessTokenStorageKey, value: value);
  }

  Future<void> removeTokenFromStorage() async {
    await secureStorage.delete(key: accessTokenStorageKey);
  }
}