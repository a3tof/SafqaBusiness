import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/auth/view/signup_view.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/features/on_boarding/view/widgets/on_boarding_page_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  var currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  void _markSeen() {
    getIt<CacheHelper>().saveData(key: CacheKeys.onboardingSeen, value: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    final loginBtn = CustomButton(
      onPressed: () {
        _markSeen();
        Navigator.pushNamed(context, SigninView.routeName);
      },
      text: S.of(context).logIn,
      textColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );

    final signupBtn = CustomButton(
      onPressed: () {
        _markSeen();
        Navigator.pushNamed(context, SignupView.routeName);
      },
      text: S.of(context).signUp,
      textColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );

    final content = Column(
      children: [
        Expanded(child: OnBoardingPageView(pageController: pageController)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 24.0 : kHorizontalPadding.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
              DotsIndicator(
                dotsCount: 3,
                position: currentPage.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).colorScheme.primary,
                  color: Theme.of(context).colorScheme.primary.withAlpha(
                    (0.3 * 255).toInt(),
                  ),
                  size: Size.square(8.rSp(context)),
                  activeSize: Size.square(8.rSp(context)),
                ),
              ),
              SizedBox(height: isTabletOrUp ? 20.0 : 20.h),
              if (isTabletOrUp)
                ResponsiveFormRow(
                  leading: loginBtn,
                  trailing: signupBtn,
                )
              else ...[
                loginBtn,
                SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
                signupBtn,
              ],
              SizedBox(height: isTabletOrUp ? 24.0 : 24.h),
            ],
          ),
        ),
      ],
    );

    return SafeArea(
      child: ResponsiveFormShell(
        enabled: isTabletOrUp,
        maxWidth: 700,
        child: isTabletOrUp ? ResponsiveFormSection(child: content) : content,
      ),
    );
  }
}
