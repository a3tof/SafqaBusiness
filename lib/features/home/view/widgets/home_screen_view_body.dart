import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/view/item_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_auction_view.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/home/view/widgets/complete_profile_dialog.dart';
import 'package:safqaseller/features/home/view/widgets/home_action_card.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';
import 'package:safqaseller/features/home/view_model/home_view_model_state.dart';
import 'package:safqaseller/features/notifications/view/notifications_view.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model_state.dart';
import 'package:safqaseller/features/profile/view/profile_view.dart';

import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
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
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationsViewModel>().loadNotifications();
    });
  }

  /// Returns true when the seller has not yet completed their profile,
  /// either because the cache says so or because the API returned "Seller not found".
  bool _isProfileIncomplete(HomeViewModelState homeState) {
    if (widget.showCompleteProfile) return true;

    if (homeState is HomeSuccess) {
      return false;
    }

    if (homeState is HomeFailure) {
      final error = homeState.error.toLowerCase();
      if (error.contains('seller not found') || error.contains('403') || error.contains('404')) {
        return true;
      }
    }

    return false;
  }

  void _maybeShowDialog({HomeViewModelState? homeState}) {
    if (!mounted || _dialogShown) return;

    final state = homeState ?? context.read<HomeViewModel>().state;
    if (!_isProfileIncomplete(state)) return;

    _dialogShown = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteProfileDialog(
        forcedMode: true,
        onComplete: () {},
      ),
    ).whenComplete(() => _dialogShown = false);
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
        Uri.parse('https://safqa-navy.vercel.app/seller-statistics'),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              final profileLocked = !isLoading && _isProfileIncomplete(state);

              // Show the dialog once when the state first resolves as incomplete.
              if (profileLocked) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _maybeShowDialog(homeState: state),
                );
              }

              final isTabletOrUp = Breakpoints.isTabletOrUp(context);

              return Skeletonizer(
                enabled: isLoading,
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    onRefresh: _refreshHome,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: isTabletOrUp ? 24.0 : 24.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: ResponsiveFormShell(
                            enabled: isTabletOrUp,
                            maxWidth: 700,
                            child: ResponsiveFormSection(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
                                  const Center(child: _SafqaBusinessLogo()),
                                  SizedBox(height: isTabletOrUp ? 24.0 : 24.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
                              child: _GreetingRow(
                                storeName: storeName,
                                logoBytes: logoBytes,
                                onProfileTap: _openProfile,
                                onNotificationTap: _openNotifications,
                              ),
                            ),
                              if (state is HomeFailure &&
                                  !_isProfileIncomplete(state)) ...[
                                SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
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
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ],
                              SizedBox(height: isTabletOrUp ? 32.0 : 32.h),
                              // ── Action cards ─────────────────────────────────
                              // When the profile is incomplete, overlay a dim
                              // shield and absorb all taps so nothing is reachable.
                              Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
                                    child: Column(
                                      children: [
                                      if (isTabletOrUp)
                                        ResponsiveFormRow(
                                          leading: HomeActionCard(
                                            label: S.of(context).kNewLotAuction,
                                            showAddIcon: true,
                                            backgroundImage: Assets.imagesFrame1,
                                            onTap: () async {
                                              await Navigator.pushNamed(context, LotAuctionView.routeName);
                                              await _refreshHome();
                                            },
                                          ),
                                          trailing: HomeActionCard(
                                            label: S.of(context).kNewSingleAuction,
                                            showAddIcon: true,
                                            backgroundImage: Assets.imagesFrame1,
                                            onTap: () async {
                                              await Navigator.pushNamed(context, ItemAuctionView.routeName);
                                              await _refreshHome();
                                            },
                                          ),
                                        )
                                      else ...[
                                        HomeActionCard(
                                          label: S.of(context).kNewLotAuction,
                                          showAddIcon: true,
                                          backgroundImage: Assets.imagesFrame1,
                                          onTap: () async {
                                            await Navigator.pushNamed(context, LotAuctionView.routeName);
                                            await _refreshHome();
                                          },
                                        ),
                                        SizedBox(height: 16.h),
                                        HomeActionCard(
                                          label: S.of(context).kNewSingleAuction,
                                          showAddIcon: true,
                                          backgroundImage: Assets.imagesFrame1,
                                          onTap: () async {
                                            await Navigator.pushNamed(context, ItemAuctionView.routeName);
                                            await _refreshHome();
                                          },
                                        ),
                                      ],
                                      SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
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
                                            SizedBox(width: isTabletOrUp ? 8.0 : 8.w),
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
                                // Translucent lock overlay — absorbs all taps
                                // when profile completion is required.
                                if (profileLocked)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () => _maybeShowDialog(homeState: state),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black.withValues(alpha: 0.6)
                                              : Colors.black.withValues(alpha: 0.45),
                                          borderRadius: BorderRadius.circular(12.rSp(context)),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.lock_rounded,
                                                color: Colors.white,
                                                size: 40.rSp(context),
                                              ),
                                              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                                              Text(
                                                'Complete your profile to unlock',
                                                style: TextStyles.semiBold14(context)
                                                    .copyWith(color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ), // End Stack
                            ],
                          ), // End Column
                        ), // End ResponsiveFormSection
                      ), // End ResponsiveFormShell
                    ), // End Center
                  ), // End ConstrainedBox
                ), // End SingleChildScrollView
              ), // End RefreshIndicator
            ), // End LayoutBuilder
          ); // End Skeletonizer
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
              fontSize: 40.rSp(context),
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 40.rSp(context),
              fontWeight: FontWeight.normal,
              color: Theme.of(context).hintColor,
            ),
          ),
          TextSpan(
            text: 'Business',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 24.rSp(context),
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.primary,
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
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
                  width: isTabletOrUp ? 70.0 : 70.w,
                  height: isTabletOrUp ? 70.0 : 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: logoBytes != null
                        ? Image.memory(logoBytes!, fit: BoxFit.cover)
                        : Icon(
                            Icons.store_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 38.rSp(context),
                          ),
                  ),
                ),
              ),
              SizedBox(width: isTabletOrUp ? 8.0 : 8.w),
              Flexible(
                child: SizedBox(
                  width: isTabletOrUp ? 103.0 : 103.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).homeWelcomeGreeting,
                        style: TextStyles.regular18(
                          context,
                        ).copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTabletOrUp ? 2.0 : 2.h),
                      Text(
                        storeName,
                        style: TextStyles.medium18(
                          context,
                        ).copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotificationBadgeIcon(onTap: onNotificationTap),
            SizedBox(width: isTabletOrUp ? 8.0 : 8.w),
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
                color: Theme.of(context).colorScheme.primary,
                size: 28.rSp(context),
              ),
              if (hasUnread)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 9.rSp(context),
                    height: 9.rSp(context),
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
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28.rSp(context)),
    );
  }
}
