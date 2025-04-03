import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/interceptors/access_token_interceptor.dart';
import 'package:split_trip/interceptors/common_interceptor.dart';
import 'package:split_trip/constants/api_constants.dart';

class ProfileRepository {
  final http.Client _client;

  ProfileRepository()
      : _client = InterceptedClient.build(
    interceptors: [CommonInterceptor(), AccessTokenInterceptor()],
  );

  Future<http.Response> changePassword(Map<String, dynamic> data) async {
    return await _client.put(scheme("/v1/profile/password"), body: jsonEncode(data));
  }

  Future<http.Response> changeEmail(Map<String, dynamic> data) async {
    return await _client.put(scheme("/v1/profile/email"), body: jsonEncode(data));
  }

  Future<http.Response> updateProfile(Map<String, dynamic> data) async {
    return await _client.put(scheme("/v1/profile"), body: jsonEncode(data));
  }

  Future<http.Response> uploadAvatar(File file) async {
    final Uri uri = scheme("/v1/profile/avatar");

    final request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('avatar', file.path));

    final streamedResponse = await _client.send(request);

    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> setFirebaseCloudMessagingToken(String token) async {
    return await _client.put(scheme("/v1/profile/firebase-cloudMessaging-token"), body: jsonEncode({"token": token}));
  }
}
