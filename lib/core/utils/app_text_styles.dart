import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';

extension ResponsiveFontSize on num {
  double rSp(BuildContext context) {
    return Breakpoints.isTabletOrUp(context) ? toDouble() : sp;
  }
}

abstract class TextStyles {
  static TextStyle regular11(BuildContext context) {
    return TextStyle(fontSize: 11.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle semiBold11(BuildContext context) {
    return TextStyle(fontSize: 11.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular12(BuildContext context) {
    return TextStyle(fontSize: 12.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle regular13(BuildContext context) {
    return TextStyle(fontSize: 13.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle bold13(BuildContext context) {
    return TextStyle(fontSize: 13.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle semiBold13(BuildContext context) {
    return TextStyle(fontSize: 13.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular14(BuildContext context) {
    return TextStyle(fontSize: 14.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle medium14(BuildContext context) {
    return TextStyle(fontSize: 14.rSp(context), fontWeight: FontWeight.w500);
  }

  static TextStyle semiBold14(BuildContext context) {
    return TextStyle(fontSize: 14.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle medium15(BuildContext context) {
    return TextStyle(fontSize: 15.rSp(context), fontWeight: FontWeight.w500);
  }

  static TextStyle semiBold15(BuildContext context) {
    return TextStyle(fontSize: 15.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular16(BuildContext context) {
    return TextStyle(fontSize: 16.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle bold16(BuildContext context) {
    return TextStyle(fontSize: 16.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle medium16(BuildContext context) {
    return TextStyle(fontSize: 16.rSp(context), fontWeight: FontWeight.w500);
  }

  static TextStyle semiBold16(BuildContext context) {
    return TextStyle(fontSize: 16.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular18(BuildContext context) {
    return TextStyle(fontSize: 18.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle medium18(BuildContext context) {
    return TextStyle(fontSize: 18.rSp(context), fontWeight: FontWeight.w500);
  }

  static TextStyle bold18(BuildContext context) {
    return TextStyle(fontSize: 18.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle regular20(BuildContext context) {
    return TextStyle(fontSize: 20.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle medium20(BuildContext context) {
    return TextStyle(fontSize: 20.rSp(context), fontWeight: FontWeight.w500);
  }

  static TextStyle semiBold20(BuildContext context) {
    return TextStyle(fontSize: 20.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular22(BuildContext context) {
    return TextStyle(fontSize: 22.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle bold22(BuildContext context) {
    return TextStyle(fontSize: 22.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle bold23(BuildContext context) {
    return TextStyle(fontSize: 23.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle semiBold24(BuildContext context) {
    return TextStyle(fontSize: 24.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle regular26(BuildContext context) {
    return TextStyle(fontSize: 26.rSp(context), fontWeight: FontWeight.normal);
  }

  static TextStyle bold28(BuildContext context) {
    return TextStyle(fontSize: 28.rSp(context), fontWeight: FontWeight.bold);
  }

  static TextStyle semiBold19(BuildContext context) {
    return TextStyle(fontSize: 19.rSp(context), fontWeight: FontWeight.w600);
  }

  static TextStyle bold19(BuildContext context) {
    return TextStyle(fontSize: 19.rSp(context), fontWeight: FontWeight.bold);
  }
}
