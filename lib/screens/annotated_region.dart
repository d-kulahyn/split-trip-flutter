import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemAnnotatedRegion extends StatefulWidget {
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final Widget child;

  const SystemAnnotatedRegion({super.key, required this.child, required this.systemUiOverlayStyle});

  @override
  State<SystemAnnotatedRegion> createState() => SystemAnnotatedRegionState();
}

class SystemAnnotatedRegionState<T extends SystemAnnotatedRegion> extends State<T> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.systemUiOverlayStyle,
      child: widget.child
    );
  }
}
