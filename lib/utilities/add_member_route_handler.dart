import 'package:flutter/material.dart';
import 'package:split_trip/utilities/route_handler.dart';

import '../screens/add_member_screen.dart';

class AddMemberRouteHandler implements RouteHandler {
  final Uri uri;
  String? _groupId;

  AddMemberRouteHandler(this.uri);

  @override
  bool matches(Uri uri) {
    final RegExp regExp = RegExp(r'^/groups/([a-f0-9\-]+)$');
    final match = regExp.firstMatch(uri.path);
    if (match != null) {
      _groupId = match.group(1);
      return true;
    }
    return false;
  }

  @override
  String get route => AddMemberScreen.routeName;

  @override
  Map<String, dynamic>? get arguments =>
      _groupId != null ? {'groupId': _groupId} : null;

  @override
  Widget? get builder => _groupId != null ? AddMemberScreen(groupId: _groupId!) : null;
}
