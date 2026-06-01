import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, largeTablet, desktop }

class Breakpoints {
  const Breakpoints._();

  static const double tablet = 600;
  static const double largeTablet = 900;
  static const double desktop = 1200;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static ScreenSize of(BuildContext context) {
    final width = widthOf(context);
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= largeTablet) return ScreenSize.largeTablet;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenSize.mobile;

  static bool isTabletOrUp(BuildContext context) => widthOf(context) >= tablet;

  static bool isLargeTabletOrUp(BuildContext context) =>
      widthOf(context) >= largeTablet;

  static bool isDesktopOrUp(BuildContext context) =>
      widthOf(context) >= desktop;
}
