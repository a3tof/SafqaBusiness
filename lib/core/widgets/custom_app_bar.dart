import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

AppBar buildAppBar({required BuildContext context, required String title}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final theme = Theme.of(context);

  return AppBar(
    surfaceTintColor: Colors.transparent,
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
        size: 22.rSp(context),
      ),
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 28.rSp(context),
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
        fontFamily: isArabic ? 'Cairo' : 'AlegreyaSC',
      ),
    ),
  );
}
