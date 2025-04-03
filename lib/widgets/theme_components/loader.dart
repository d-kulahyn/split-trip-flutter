import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget screenLoader() {
  return Platform.isAndroid ?  const RefreshProgressIndicator() : const CupertinoActivityIndicator();
}