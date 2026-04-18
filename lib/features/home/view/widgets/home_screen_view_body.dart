import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/view/item_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_auction_view.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model_state.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/home/view/widgets/complete_profile_dialog.dart';
import 'package:safqaseller/features/home/view/widgets/home_action_card.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';
import 'package:safqaseller/features/home/view_model/home_view_model_state.dart';
import 'package:safqaseller/features/notifications/view/notifications_view.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model_state.dart';
import 'package:safqaseller/features/profile/view/profile_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/wallet/view/wallet_view.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenViewBody extends StatefulWidget {
  const HomeScreenViewBody({super.key, this.showCompleteProfile = false});

  final bool showCompleteProfile;

  @override
  State<HomeScreenViewBody> createState() => _HomeScreenViewBodyState();
}

class _HomeScreenViewBodyState extends State<HomeScreenViewBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowDialog();
      getIt<NotificationsViewModel>().loadNotifications();
    });
  }

  void _maybeShowDialog() {
    if (!mounted) return;

    final showFromLogin = widget.showCompleteProfile;
    final authState = context.read<AuthViewModel>().state;
    final profileVM = context.read<ProfileViewModel>();
    final showFromRole =
        authState is AuthAuthenticated &&
        authState.role == 'User' &&
        !profileVM.isProfileCompleted;

    if (showFromLogin || showFromRole) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CompleteProfileDialog(onComplete: () {}),
      );
    }
  }

  Future<void> _refreshHome() async {
    await context.read<HomeViewModel>().loadHomeData();
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, ProfileView.routeName);
    if (mounted) {
      context.read<HomeViewModel>().loadHomeData();
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.pushNamed(context, NotificationsView.routeName);
    if (mounted) {
      getIt<NotificationsViewModel>().loadNotifications();
    }
  }

  Future<void> _openStatistics() async {
    try {
      final launched = await launchUrl(
        Uri.parse('https://www.mohamedhamdy.dev/'),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) return;
    } on PlatformException {
      debugPrint(
        'Failed to launch statistics URL: plugin channel unavailable.',
      );
    } catch (_) {
      debugPrint('Failed to launch statistics URL.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NotificationsViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<HomeViewModel, HomeViewModelState>(
            builder: (context, state) {
              final isLoading = state is HomeLoading || state is HomeInitial;
              final storeName = state is HomeSuccess
                  ? state.data.storeName
                  : 'Seller';
              final logoBytes = state is HomeSuccess
                  ? state.data.logoBytes
                  : null;

              return Skeletonizer(
                enabled: isLoading,
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    onRefresh: _refreshHome,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 4.h),
                            const Center(child: _SafqaBusinessLogo()),
                            SizedBox(height: 24.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: _GreetingRow(
                                storeName: storeName,
                                logoBytes: logoBytes,
                                onProfileTap: _openProfile,
                                onNotificationTap: _openNotifications,
                              ),
                            ),
                            if (state is HomeFailure) ...[
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.error,
                                        style: TextStyles.regular13(
                                          context,
                                        ).copyWith(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => context
                                          .read<HomeViewModel>()
                                          .loadHomeData(),
                                      child: Text(
                                        'Retry',
                                        style: TextStyles.semiBold13(context)
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 32.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  HomeActionCard(
                                    label: S.of(context).kNewLotAuction,
                                    showAddIcon: true,
                                    backgroundImage: Assets.imagesFrame1,
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        LotAuctionView.routeName,
                                      );
                                      await _refreshHome();
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  HomeActionCard(
                                    label: S.of(context).kNewSingleAuction,
                                    showAddIcon: true,
                                    backgroundImage: Assets.imagesFrame1,
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                          context,
                                          ItemAuctionView.routeName,
                                        );
                                        await _refreshHome();
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: HomeActionCard(
                                          label: S.of(context).kHistory,
                                          backgroundImage: Assets.imagesFrame1,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              HistoryView.routeName,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: HomeActionCard(
                                          label: S.of(context).kStatistics,
                                          backgroundImage: Assets.imagesFrame2,
                                          onTap: _openStatistics,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
  const _GreetingRow({
    required this.storeName,
    required this.onProfileTap,
    required this.onNotificationTap,
    this.logoBytes,
  });

  final String storeName;
  final Uint8List? logoBytes;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
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
                  child: ClipOval(
                    child: logoBytes != null
                        ? Image.memory(logoBytes!, fit: BoxFit.cover)
                        : Icon(
                            Icons.store_rounded,
                            color: AppColors.primaryColor,
                            size: 38.sp,
                          ),
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
                        storeName,
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
            _NotificationBadgeIcon(onTap: onNotificationTap),
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

class _NotificationBadgeIcon extends StatelessWidget {
  const _NotificationBadgeIcon({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsViewModel, NotificationsState>(
      builder: (context, state) {
        final hasUnread = context
            .read<NotificationsViewModel>()
            .hasUnreadOrUnseen;

        return GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: AppColors.primaryColor,
                size: 28.sp,
              ),
              if (hasUnread)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 9.sp,
                    height: 9.sp,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
