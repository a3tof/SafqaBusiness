import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/main.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.subtitle,
    required this.title,
    this.showLanguageIcon = false,
  });

  final String image;
  final String subtitle;
  final Widget title;
  final bool showLanguageIcon;

  void _toggleLanguage(BuildContext context) {
    final currentCode = Localizations.localeOf(context).languageCode;
    final newLocale =
        currentCode == 'ar' ? const Locale('en') : const Locale('ar');
    getIt<CacheHelper>().saveData(
      key: CacheKeys.language,
      value: newLocale.languageCode == 'ar' ? 'arabic' : 'english',
    );
    SafqaSeller.of(context)?.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 24.0 : 24.w, vertical: isTabletOrUp ? 8.0 : 8.h),
      child: Column(
        children: [
          Align(
            alignment:
                isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: () => _toggleLanguage(context),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isTabletOrUp ? 8.0 : 8.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.imagesIconoirLanguage,
                      width: 24.rSp(context),
                      height: 24.rSp(context),
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: isTabletOrUp ? 8.0 : 8.w),
                    Text(
                      isArabic ? 'AR' : 'EN',
                      style: TextStyles.semiBold13(context).copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Image.asset(
              Assets.imagesSAFQA,
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          const Spacer(flex: 1),
          Flexible(
            flex: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.rSp(context)),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(flex: 1),
          title,
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          Flexible(
            flex: 3,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyles.regular13(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.25,
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
