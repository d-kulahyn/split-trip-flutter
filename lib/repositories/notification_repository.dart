import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/interceptors/access_token_interceptor.dart';
import 'package:split_trip/interceptors/common_interceptor.dart';
import 'package:split_trip/constants/api_constants.dart';

class NotificationRepository {
  final http.Client _client;

  NotificationRepository()
      : _client = InterceptedClient.build(
    interceptors: [CommonInterceptor(), AccessTokenInterceptor()],
  );

  Future<http.Response> debtReminder(int debtId) async {
    return await _client.post(scheme("/v1/notifications/debt-reminder/$debtId"));
  }
}
