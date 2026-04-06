import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';

AppBar buildAppBar({required BuildContext context, required String title}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          // Handle the case where there is no back navigation
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(S.of(context).kNoPreviousPageTo)),
          // );
        }
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: AppColors.primaryColor,
        size: 22.sp,
      ),
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
        fontFamily: isArabic ? 'Cairo' : 'AlegreyaSC',
      ),
    ),
  );
}
