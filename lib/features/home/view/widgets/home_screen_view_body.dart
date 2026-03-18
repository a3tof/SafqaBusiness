import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/home/view/widgets/complete_profile_dialog.dart';
import 'package:safqaseller/features/home/view/widgets/home_action_card.dart';

class HomeScreenViewBody extends StatefulWidget {
  const HomeScreenViewBody({super.key});

  @override
  State<HomeScreenViewBody> createState() => _HomeScreenViewBodyState();
}

class _HomeScreenViewBodyState extends State<HomeScreenViewBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDialog());
  }

  void _maybeShowDialog() {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteProfileDialog(
        onComplete: () {
          // TODO: navigate to profile-completion screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Logo  (design: 4 px below 44 px status bar) ─────────────────
            SizedBox(height: 4.h),
            const Center(child: _SafqaBusinessLogo()),

            // ── Greeting  (design: 24 px below logo) ─────────────────────────
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const _GreetingRow(),
            ),

            // ── Scrollable cards  (design: 32 px below greeting) ─────────────
            SizedBox(height: 32.h),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
                child: Column(
                  children: [
                    HomeActionCard(
                      label: 'New Lot Auction',
                      showAddIcon: true,
                      backgroundImage: Assets.imagesHammer,
                      onTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    HomeActionCard(
                      label: 'New Single Auction',
                      showAddIcon: true,
                      backgroundImage: Assets.imagesHammer,
                      onTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: HomeActionCard(
                            label: 'History',
                            backgroundImage: Assets.imagesFrame1,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: HomeActionCard(
                            label: 'Statistics',
                            backgroundImage: Assets.imagesFrame2,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ────────────────────────────────────────────────────────────

/// "safqa.Business" wordmark.
/// Font: AlegreyaSC (pubspec family name — no space).
/// Sizes: 40 sp for "safqa" / "." and 24 sp for "Business", per Figma.
class _SafqaBusinessLogo extends StatelessWidget {
  const _SafqaBusinessLogo();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'safqa',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 40.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 40.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF808080),
            ),
          ),
          TextSpan(
            text: 'Business',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Greeting row: avatar + two-line text + action icons.
/// Design: left side 70×70 circle photo + "Welcome!" (grey 18 sp) /
/// "Hello, Seller!" (primary 18 sp medium), constrained to 103 px wide.
class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar + text
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
                border: Border.all(
                  color: const Color(0xFFCCDDEE),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.primaryColor,
                size: 38.sp,
              ),
            ),
            SizedBox(width: 8.w),
            // Constrained to 103 px as in the Figma spec
            Flexible(
              child: SizedBox(
                width: 103.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyles.regular18(context).copyWith(
                        color: const Color(0xFF808080),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Hello, Seller!',
                      style: TextStyles.medium18(context).copyWith(
                        color: AppColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),

        // Notification + profile icons (28 sp, primary colour)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIcon(icon: Icons.notifications_outlined, onTap: () {}),
            SizedBox(width: 8.w),
            _HeaderIcon(icon: Icons.person_outline_rounded, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

/// Small tappable icon button used in the header.
class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.primaryColor, size: 28.sp),
    );
  }
}
