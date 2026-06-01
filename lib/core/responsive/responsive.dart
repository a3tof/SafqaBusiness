import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';

T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  T? largeTablet,
  T? desktop,
}) {
  return switch (Breakpoints.of(context)) {
    ScreenSize.mobile => mobile,
    ScreenSize.tablet => tablet ?? mobile,
    ScreenSize.largeTablet => largeTablet ?? desktop ?? tablet ?? mobile,
    ScreenSize.desktop => desktop ?? largeTablet ?? tablet ?? mobile,
  };
}

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.largeTablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? largeTablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return switch (Breakpoints.of(context)) {
      ScreenSize.mobile => mobile(context),
      ScreenSize.tablet => (tablet ?? mobile)(context),
      ScreenSize.largeTablet => (largeTablet ?? desktop ?? tablet ?? mobile)(
        context,
      ),
      ScreenSize.desktop => (desktop ?? largeTablet ?? tablet ?? mobile)(
        context,
      ),
    };
  }
}
