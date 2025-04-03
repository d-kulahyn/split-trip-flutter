import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CommonInterceptor implements InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] =  'application/json';

    request.headers['UUID'] = const Uuid().v4();

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
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