import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/responsive/responsive.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  Color? barrierColor,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    barrierColor: barrierColor,
    builder: (dialogContext) {
      final maxWidth = responsiveValue<double>(
        dialogContext,
        mobile: double.infinity,
        tablet: 480,
        largeTablet: 520,
        desktop: 560,
      );

      final child = builder(dialogContext);
      if (!Breakpoints.isTabletOrUp(dialogContext)) return child;

      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveValue<double>(
              dialogContext,
              mobile: 24,
              tablet: 32,
              largeTablet: 40,
              desktop: 48,
            ),
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      );
    },
  );
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useRootNavigator = true,
  Color? backgroundColor,
  ShapeBorder? shape,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: Breakpoints.isTabletOrUp(context)
        ? Colors.transparent
        : (backgroundColor ?? Theme.of(context).scaffoldBackgroundColor),
    shape: Breakpoints.isTabletOrUp(context) ? null : shape,
    constraints: BoxConstraints(
      maxWidth: responsiveValue<double>(
        context,
        mobile: double.infinity,
        tablet: 520,
        largeTablet: 560,
        desktop: 600,
      ),
    ),
    builder: (sheetContext) {
      final child = builder(sheetContext);
      if (!Breakpoints.isTabletOrUp(sheetContext)) return child;

      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color:
              backgroundColor ?? Theme.of(sheetContext).scaffoldBackgroundColor,
          shape:
              shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
          child: child,
        ),
      );
    },
  );
}
