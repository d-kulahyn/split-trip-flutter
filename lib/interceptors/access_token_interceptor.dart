import 'dart:async';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/services/access_token_storage_manager.dart';
import 'package:logger/logger.dart';

class AccessTokenInterceptor implements InterceptorContract {
  final AccessTokenStorageManager accessTokenStorageManager;

  AccessTokenInterceptor()
      : accessTokenStorageManager = AccessTokenStorageManager();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    Logger logger = Logger();
    String? accessToken = await accessTokenStorageManager.getTokenFromStorage();
    if (accessToken != null) {
      request.headers['Authorization'] = "Bearer $accessToken";
    }

    if (request is Request) {
      logger.d({
        'request': {'url': request.url, 'method': request.method, 'body': request.body, 'headers': request.headers}
      });
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response is Response) {
      Logger logger = Logger();
      logger.d({'response': response.body, "code": response.statusCode});
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
