import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/interceptors/access_token_interceptor.dart';
import 'package:split_trip/interceptors/common_interceptor.dart';
import 'package:split_trip/constants/api_constants.dart';

class CurrencyRepository {
  final http.Client _client;

  CurrencyRepository()
      : _client = InterceptedClient.build(
    interceptors: [CommonInterceptor(), AccessTokenInterceptor()],
  );

  Future<http.Response> rates(String baseCurrency) async {
    return await _client.get(scheme("/v1/currencies/$baseCurrency/rates"));
  }

  Future<http.Response> codes() async {
    return await _client.get(scheme("/v1/currencies/codes"));
  }
}
