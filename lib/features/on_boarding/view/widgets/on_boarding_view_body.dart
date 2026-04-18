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
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: OnBoardingPageView(pageController: pageController)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                DotsIndicator(
                  dotsCount: 3,
                  position: currentPage.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).colorScheme.primary,
                    color: Theme.of(context).colorScheme.primary.withAlpha(
                      (0.3 * 255).toInt(),
                    ),
                    size: Size.square(8.r),
                    activeSize: Size.square(8.r),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onPressed: () {
                    _markSeen();
                    Navigator.pushNamed(context, SigninView.routeName);
                  },
                  text: S.of(context).logIn,
                  textColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  onPressed: () {
                    _markSeen();
                    Navigator.pushNamed(context, SignupView.routeName);
                  },
                  text: S.of(context).signUp,
                  textColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
