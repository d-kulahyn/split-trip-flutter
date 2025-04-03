import 'package:split_trip/utilities/route_handler.dart';

class RouteProcessor {
  final List<RouteHandler> handlers;

  RouteProcessor(this.handlers);

  RouteHandler process(Uri uri) {
    for (final handler in handlers) {
      if (handler.matches(uri)) {
        return handler;
      }
    }
    throw Exception('No matching route found');
  }
}