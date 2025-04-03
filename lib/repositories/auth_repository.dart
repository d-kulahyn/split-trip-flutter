import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/enums/social_provider_enums.dart';
import 'package:split_trip/interceptors/access_token_interceptor.dart';
import 'package:split_trip/interceptors/common_interceptor.dart';
import 'package:split_trip/constants/api_constants.dart';

class AuthRepository {
  final http.Client _client;

  AuthRepository()
      : _client = InterceptedClient.build(
    interceptors: [CommonInterceptor(), AccessTokenInterceptor()],
  );

  Future<http.Response> register(Map<String, dynamic> formData) {
    return _client.post(scheme("/v1/auth/register"),
        body: jsonEncode(formData));
  }

  Future<http.Response> userMe() {
    return _client.get(scheme('/v1/auth/user/me'));
  }

  Future<http.Response> signOut() async {
    return _client.post(scheme("/v1/auth/logout"), body: {});
  }

  Future<http.Response> sendConfirmationCode() async {
    return _client.post(scheme("/v1/auth/sendConfirmationCode"), body: {});
  }

  Future<http.Response> signIn(Map<String, dynamic> forData) {
    return _client.post(
      scheme("/v1/auth/login"),
      body: jsonEncode(forData)
    );
  }
  
  Future<http.Response> socialSignIn(String accessToken, SocialProviderEnums socialProviderEnum) {
    return _client.post(scheme("/v1/auth/social/${socialProviderEnum.name}"), body: jsonEncode({'access_token': accessToken}));
  }

  Future<http.Response> confirmEmail(Map<String, dynamic> data) async {
    return await _client.post(scheme("/v1/auth/confirm-email"), body: jsonEncode(data));
  }
}
