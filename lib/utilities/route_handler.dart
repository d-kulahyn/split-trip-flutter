import 'package:flutter/material.dart';

abstract class RouteHandler {
  bool matches(Uri uri);
  String get route;
  Map<String, dynamic>? get arguments;
  Widget? get builder;
}