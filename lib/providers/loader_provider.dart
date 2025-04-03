import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  bool _show = false;

  bool get show => _show;

  void toggle() {
    _show = !_show;
    notifyListeners();
  }
}