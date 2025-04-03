import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:split_trip/models/group_model.dart';
import 'package:split_trip/screens/account_screen.dart';
import 'package:split_trip/screens/group_action_screen.dart';
import 'package:split_trip/screens/group_settings_screen.dart';
import 'package:split_trip/screens/group_view_screen.dart';
import 'package:split_trip/screens/login_screen.dart';
import 'package:split_trip/screens/logout_screen.dart';
import 'package:split_trip/screens/main_screen.dart';
import 'package:split_trip/screens/register_screen.dart';

import '../screens/base_screen.dart';

class RouteGenerator {

  static final Map<String, Widget Function(BuildContext)> routes = {
    MainScreen.routeName: (BuildContext context) => const MainScreen(),
    BaseScreen.routeName: (BuildContext context) => const BaseScreen(),
    LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
    RegisterScreen.routeName: (BuildContext context) => const RegisterScreen(),
    LogoutScreen.routeName: (BuildContext context) => const LogoutScreen(),
    AccountScreen.routeName: (BuildContext context) => const AccountScreen(),
    GroupActionScreen.routeName: (BuildContext context) => GroupActionScreen(
        arguments: ModalRoute.of(context)!.settings.arguments as Map?,
    ),
    GroupViewScreen.routeName: (BuildContext context) => GroupViewScreen(
        group: ModalRoute.of(context)!.settings.arguments as GroupModel
    ),
    GroupSettingsScreen.routeName: (BuildContext context) => GroupSettingsScreen(
      group: ModalRoute.of(context)!.settings.arguments as GroupModel
    ),
  };
}