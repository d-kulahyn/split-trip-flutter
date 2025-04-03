import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:split_trip/services/overlay_service.dart';
import 'package:split_trip/widgets/split_trip.dart';

import '../models/auth_model.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final FCMToken = await _firebaseMessaging.getToken();

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    if (FCMToken == null) return;

    final BuildContext? context = OverlayService.navigatorKey.currentState?.context;

    if (context == null) return;

    AuthModel.firebaseCloudMessagingToken = FCMToken;
  }
}