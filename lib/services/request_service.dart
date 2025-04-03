import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:split_trip/utilities/errors_formatter.dart';

import '../screens/login_screen.dart';
import 'overlay_service.dart';

class RequestService<T> {

  static Future<T?> send<T>(BuildContext context, Future<Response> request, {Function(T data)? onSuccess, ValueNotifier? errorsNotifier}) async {
    try {

      final Response response = await request;
      final data = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.unauthorized) {
        _handleUnauthorized(context);
        return null;
      }

      if (response.statusCode == HttpStatus.badRequest) {
        _handleBadRequest<T>(data);
        return null;
      }

      if (response.statusCode == HttpStatus.unprocessableEntity) {
        _handleValidationErrors<T>(context, data, errorsNotifier);
        return null;
      }

      if (onSuccess != null ) onSuccess(data);

      return data;
    } on SocketException catch (error) {
      OverlayService.showOverlayMessage('No internet connection!');
    } on Exception catch (error) {
      OverlayService.showOverlayMessage('Something went wrong. Try again later.');
      logError(error);
    }

    return null;
  }

  static void logError(error) {
    print(error);
  }

  static void _handleUnauthorized(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
  }

  static void _handleBadRequest<T>(T data) {
    String message = 'Bad Request';

    if (data is Map && data['message'] != null) {
      message = data['message'];
    }

    OverlayService.showOverlayMessage(message);
  }

  static void _handleValidationErrors<T>(BuildContext context, T data, ValueNotifier? errorsNotifier) {
    if (errorsNotifier != null && data is Map && data['errors'] != null) {
     errorsNotifier.value = ErrorsFormatter.format(data['errors'] ?? {});
    }
  }
}
