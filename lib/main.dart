import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_trip/firebase_options.dart';
import 'package:split_trip/widgets/split_trip.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/theme_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  initializeDateFormatting('en_US');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SplitTrip());
}