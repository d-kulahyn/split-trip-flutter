import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double cTextFormFieldHeight = 55;
const double cTextFormFieldErrorHeight = 60;
const double cTextFormFieldGeneralHeight = cTextFormFieldHeight + cTextFormFieldErrorHeight;
const Color cTextFormFieldFocusedColor = Color.fromRGBO(123, 129, 146, 0.2);
const Color cTextFormFieldUnFocusedColor = Color.fromRGBO(123, 129, 146, 1);
const double cTextFormFieldHintFontSize = 14;
const BorderSide cTextFormFieldBorderSideErrorMessageColor = BorderSide(color: Color.fromRGBO(240, 34, 83, 1), width: 1);
const double cTextFormFieldBorderRadius = 10.0;
const double cTextFormFieldErrorMessageTop = 5;
const Color cTextFormFieldErrorMessageColor = Color.fromRGBO(240, 34, 83, 1);
const double cTextFormFieldFontSize = 15;
const Color cAuthScreenBackgroundColor = Colors.white;
const EdgeInsets cAuthScreenPaddings = EdgeInsets.only(top: 40, left: 20, right: 20);
const EdgeInsets cAuthScreenLogoPaddings = EdgeInsets.only(top: 20, bottom: 50);
const TextStyle cAuthScreenTitleStyles = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
const TextStyle cAuthScreenSubTitleStyles = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(99, 104, 116, 1));
const EdgeInsets cAuthScreenFormMarginStyles = EdgeInsets.only(top: 40);
const double cIconNavigationSize = 30;
const double cSizeSocialButton = 60;
const Color mainColor = Color.fromRGBO(150, 123, 254, 1);
const cBorderInactiveColor = Color.fromRGBO(232, 232, 234, 1);
const cBorderActiveColor = mainColor;
var cInputBorderRadius = BorderRadius.circular(10);

const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Color.fromRGBO(80, 58, 255, 1),
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
);

const SystemUiOverlayStyle systemGroupViewUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Color.fromRGBO(216, 222, 255, 1),
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
);

