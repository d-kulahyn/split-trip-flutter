import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/models/auth_model.dart';
import 'package:split_trip/providers/loader_provider.dart';
import 'package:split_trip/repositories/currency_repository.dart';
import 'package:split_trip/repositories/group_repository.dart';
import 'package:split_trip/repositories/notification_repository.dart';
import 'package:split_trip/repositories/profile_repository.dart';
import 'package:split_trip/services/access_token_storage_manager.dart';
import 'package:split_trip/services/auth_service.dart';
import 'package:split_trip/services/overlay_service.dart';
import 'package:split_trip/utilities/route_generator.dart';
import 'package:split_trip/utilities/route_handler.dart';
import 'package:split_trip/widgets/theme_components/loader.dart';
import 'package:split_trip/widgets/theme_components/theme_data.dart';

import '../providers/group_provider.dart';
import '../repositories/auth_repository.dart';
import '../services/group_service.dart';
import '../utilities/add_member_route_handler.dart';
import '../utilities/default_route_handler.dart';
import '../utilities/route_processor.dart';

class SplitTrip extends StatefulWidget {
  const SplitTrip({super.key});

  @override
  SplitTripState createState() => SplitTripState();
}

class SplitTripState extends State<SplitTrip> {
  RouteHandler? handler;
  late AuthModel authModel;

  @override
  void initState() {
    super.initState();
    authModel = AuthModel();
    determineInitialRoute();
  }

  Future<void> determineInitialRoute() async {
    final accessTokenStorageManager = AccessTokenStorageManager();
    final String? token = await accessTokenStorageManager.getTokenFromStorage();
    final Uri? initialUrl = await AppLinks().getInitialLink();

    if (token != null) {
      final bool successfulLoaded = await authModel.loadUser();

      if (!successfulLoaded) {
        setState(() {
          handler = DefaultRouteHandler(isAuthenticated: false);
        });

        return;
      }
    }

    final routeProcessor = RouteProcessor([
      if (initialUrl != null) AddMemberRouteHandler(initialUrl),
      DefaultRouteHandler(isAuthenticated: token != null),
    ]);

    final result = routeProcessor.process(initialUrl ?? Uri());

    setState(() {
      handler = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (handler == null) {
      return MaterialApp(
        home: Scaffold(
          body: screenLoader(),
        ),
      );
    }

    GroupRepository groupRepository = GroupRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoaderProvider()),
        ChangeNotifierProvider.value(value: authModel),
        ChangeNotifierProvider(
          create: (context) => GroupProvider(groupRepository),
        ),
        Provider<AuthRepository>(create: (context) => AuthRepository()),
        Provider<GroupRepository>(create: (context) => groupRepository),
        Provider<CurrencyRepository>(create: (context) => CurrencyRepository()),
        Provider<NotificationRepository>(create: (context) => NotificationRepository()),
        Provider<GroupService>(create: (context) => GroupService()),
        Provider<ProfileRepository>(create: (context) => ProfileRepository()),
        Provider<AuthService>(create: (context) => AuthService(context: context, authRepository: context.read<AuthRepository>(), accessTokenStorageManager: AccessTokenStorageManager()))
      ],
      child: MaterialApp(
        navigatorKey: OverlayService.navigatorKey,
        theme: buildTheme(),
        initialRoute: handler!.route,
        routes: RouteGenerator.routes,
        onGenerateRoute: (settings) {

          if (settings.name == handler!.route) {
            return MaterialPageRoute(
              builder: (context) => handler!.builder as Widget,
            );
          }
print(settings.name);
          final builder = RouteGenerator.routes[settings.name];
          if (builder != null) {
            return MaterialPageRoute(builder: builder);
          }

          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text('404 - Not Found'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
