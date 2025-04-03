import 'package:flutter/material.dart';
import 'package:split_trip/widgets/theme_components/loader.dart';

class FutureResultBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(BuildContext, T) onSuccess;
  final Widget Function(BuildContext, Object?)? onError;

  const FutureResultBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Press button to start');
          case ConnectionState.active:
          case ConnectionState.waiting:
          return  Center(
            child: screenLoader(),
          );
          case ConnectionState.done:
            if (snapshot.hasError) {
              print(snapshot.stackTrace);
              if (onError != null) {
                return onError!(context, snapshot.error);
              }
              print(['future error', snapshot.stackTrace]);
              return const Center(
                  child: Text("Future error!")
              );
            }
            return onSuccess(context, snapshot.data as T);
        }
      },
    );
  }
}
