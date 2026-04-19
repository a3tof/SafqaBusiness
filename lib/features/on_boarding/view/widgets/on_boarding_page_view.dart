import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/features/on_boarding/view/widgets/page_view_item.dart';
import 'package:safqaseller/generated/l10n.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          showLanguageIcon: true,
          image: Assets.imagesOnboarding1,
          subtitle: S.of(context).onBoardingSubtitle1,
          title: Text(
            S.of(context).onBoardingTitle1,
            style: TextStyles.bold23(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        PageViewItem(
          showLanguageIcon: false,
          image: Assets.imagesOnboarding2,
          subtitle: S.of(context).onBoardingSubtitle2,
          title: Text(
            S.of(context).onBoardingTitle2,
            style: TextStyles.bold23(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        PageViewItem(
          showLanguageIcon: false,
          image: Assets.imagesOnboarding3,
          subtitle: S.of(context).onBoardingSubtitle3,
          title: Text(
            S.of(context).onBoardingTitle3,
            style: TextStyles.bold23(context).copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
