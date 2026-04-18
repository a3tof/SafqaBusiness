import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/on_boarding/view/on_boarding_view.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _rippleScaleAnim;
  late Animation<double> _rippleOpacityAnim;
  late Animation<double> _hammerScaleAnim;
  late Animation<double> _hammerRotateAnim;
  late Animation<double> _hammerJumpAnim;
  late Animation<Offset> _hammerSlideAnim;
  late Animation<Offset> _textSlideAnim;
  late Animation<double> _textOpacityAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _rippleScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOutQuad),
      ),
    );

    _rippleOpacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.35)),
    );

    _hammerScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _hammerJumpAnim =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: -120.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: -120.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.bounceOut)),
            weight: 60,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.55),
          ),
        );

    _hammerRotateAnim =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: -0.2, end: 0.0), weight: 100),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.5)),
        );

    _hammerSlideAnim =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1.2, 0.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.65, 0.85, curve: Curves.easeInOutCubic),
          ),
        );

    _textSlideAnim =
        Tween<Offset>(begin: const Offset(0.5, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.65, 0.85, curve: Curves.easeInOutCubic),
          ),
        );

    _textOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.68, 0.85)),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigate();
      }
    });
  }

  void _navigate() {
    if (!mounted) return;
    final cache = getIt<CacheHelper>();
    final isLoggedIn = cache.getData(key: CacheKeys.isLoggedIn) == true;
    final onboardingSeen = cache.getData(key: CacheKeys.onboardingSeen) == true;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreenView.routeName);
    } else if (onboardingSeen) {
      Navigator.pushReplacementNamed(context, SigninView.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: _rippleOpacityAnim.value,
                  child: Transform(
                    transform: Matrix4.diagonal3Values(1.6, 0.7, 1.0),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: _rippleScaleAnim.value,
                      child: Image.asset(Assets.imagesRipple, width: 100.w),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _hammerSlideAnim,
                  child: Transform.translate(
                    offset: Offset(0, _hammerJumpAnim.value),
                    child: Transform.rotate(
                      angle: _hammerRotateAnim.value * math.pi,
                      child: Transform.scale(
                        scale: _hammerScaleAnim.value,
                        child: Image.asset(Assets.imagesHammer, width: 90.w),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(30.w, 0),
                  child: SlideTransition(
                    position: _textSlideAnim,
                    child: FadeTransition(
                      opacity: _textOpacityAnim,
                      child: Image.asset(Assets.imagesSAFQA, width: 180.w),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
