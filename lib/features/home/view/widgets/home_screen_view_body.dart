import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model_state.dart';
import 'package:safqaseller/features/home/view/widgets/complete_profile_dialog.dart';
import 'package:safqaseller/features/home/view/widgets/home_action_card.dart';
import 'package:safqaseller/features/profile/view/profile_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model_state.dart';
import 'package:safqaseller/features/notifications/view/notifications_view.dart';
import 'package:safqaseller/features/wallet/view/wallet_view.dart';
import 'package:safqaseller/generated/l10n.dart';

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

    // Only show dialog if role == "User" AND profile is NOT completed
    final authState = context.read<AuthViewModel>().state;
    final profileVM = context.read<ProfileViewModel>();

    if (authState is AuthAuthenticated && authState.role == 'User') {
      if (!profileVM.isProfileCompleted) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CompleteProfileDialog(onComplete: () {}),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ProfileViewModel, ProfileViewModelState>(
          listener: (context, state) {
            // If profile just became completed, no further action needed
            // The dialog will not show again since isProfileCompleted is true
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 4.h),
              const Center(child: _SafqaBusinessLogo()),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const _GreetingRow(),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
                  child: Column(
                    children: [
                      HomeActionCard(
                        label: S.of(context).kNewLotAuction,
                        showAddIcon: true,
                        backgroundImage: Assets.imagesFrame1,
                        onTap: () {
                          Navigator.pushNamed(context, WalletView.routeName);
                        },
                      ),
                      SizedBox(height: 16.h),
                      HomeActionCard(
                        label: S.of(context).kNewSingleAuction,
                        showAddIcon: true,
                        backgroundImage: Assets.imagesFrame1,
                        onTap: () {},
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: HomeActionCard(
                              label: S.of(context).kHistory,
                              backgroundImage: Assets.imagesFrame1,
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: HomeActionCard(
                              label: S.of(context).kStatistics,
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
      ),
    );
  }
}

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

class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileView.routeName);
                  },
                  icon: Icon(
                    Icons.person_rounded,
                    color: AppColors.primaryColor,
                    size: 38.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: SizedBox(
                  width: 103.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyles.regular18(
                          context,
                        ).copyWith(color: const Color(0xFF808080)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Hello, Seller!',
                        style: TextStyles.medium18(
                          context,
                        ).copyWith(color: AppColors.primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIcon(
              icon: Icons.notifications_outlined,
              onTap: () {
                Navigator.pushNamed(context, NotificationsView.routeName);
              },
            ),
            SizedBox(width: 8.w),
            _HeaderIcon(
              icon: Icons.wallet_rounded,
              onTap: () {
                Navigator.pushNamed(context, WalletView.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }
}

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
