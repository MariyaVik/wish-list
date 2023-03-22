import 'package:flutter/material.dart';

class CurrentScreen extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  static const double _width = 600;

  const CurrentScreen({
    required this.mobile,
    required this.desktop,
    Key? key,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _width;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _width;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= _width) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
