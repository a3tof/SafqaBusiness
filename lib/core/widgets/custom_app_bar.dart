import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


AppBar buildAppBar({required BuildContext context, required String title}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final theme = Theme.of(context);

  return AppBar(
    backgroundColor: theme.appBarTheme.backgroundColor,
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          // Handle the case where there is no back navigation
        }
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: theme.colorScheme.primary,
        size: 22.sp,
      ),
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
        fontFamily: isArabic ? 'Cairo' : 'AlegreyaSC',
      ),
    ),
  );
}

