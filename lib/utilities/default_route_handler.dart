import 'package:flutter/material.dart';
import 'package:split_trip/screens/base_screen.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/utilities/route_handler.dart';

import '../screens/main_screen.dart';

class DefaultRouteHandler implements RouteHandler {
  final bool isAuthenticated;

  DefaultRouteHandler({required this.isAuthenticated});

  @override
  bool matches(Uri uri) {
    return true;
  }

  @override
  String get route => isAuthenticated ? GroupListScreen.routeName : MainScreen.routeName;

  @override
  Map<String, dynamic>? get arguments => null;

  @override
  Widget get builder => isAuthenticated ? const BaseScreen() : const MainScreen();
}
