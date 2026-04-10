import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/services/notification_service.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/auth/view_model/logout/logout_view_model.dart';
import 'package:safqaseller/features/change_password/view/change_password_view.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_header_section.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_info_field.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_menu_item.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_metrics_row.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model_state.dart';
import 'package:safqaseller/features/reviews/view/reviews_view.dart';
import 'package:safqaseller/features/wallet/view/wallet_view.dart';
import 'package:safqaseller/main.dart';
import 'package:safqaseller/generated/l10n.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  late bool _notificationsEnabled;
  bool _updatingNotifications = false;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled =
        (getIt<CacheHelper>().getData(key: CacheKeys.notificationsEnabled)
            as bool?) ??
        false;
  }

  Future<void> _refreshProfile(BuildContext context) async {
    await context.read<ProfileViewModel>().fetchProfile(showLoadingState: true);
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (_updatingNotifications) {
      return;
    }

    setState(() => _updatingNotifications = true);

    final notificationService = getIt<NotificationService>();
    var nextValue = enabled;

    if (enabled) {
      final granted = await notificationService.requestPermissions();
      nextValue = granted;

      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notification permission is required to enable alerts.',
            ),
          ),
        );
      }
    }

    await notificationService.setNotificationsEnabled(nextValue);

    if (!mounted) {
      return;
    }

    setState(() {
      _notificationsEnabled = nextValue;
      _updatingNotifications = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProfileViewModel, ProfileViewModelState>(
        builder: (context, profileState) {
          final fullName = profileState is ProfileLoaded
              ? (profileState.fullName ?? '—')
              : '—';
          final email = profileState is ProfileLoaded
              ? (profileState.email ?? '—')
              : '—';
          final phoneNumber = profileState is ProfileLoaded
              ? (profileState.phoneNumber ?? '—')
              : '—';
          final logoBytes = profileState is ProfileLoaded
              ? profileState.logoBytes
              : null;
          final rating = profileState is ProfileLoaded
              ? (profileState.rating ?? '0')
              : '0';
          final followersCount = profileState is ProfileLoaded
              ? (profileState.followersCount ?? '0')
              : '0';
          final auctionsCount = profileState is ProfileLoaded
              ? (profileState.auctionsCount ?? '0')
              : '0';
          final activePlanId = profileState is ProfileLoaded
              ? profileState.activePlanId
              : null;
          final cityLabel = profileState is ProfileLoaded
              ? ((profileState.cityName?.trim().isNotEmpty ?? false)
                    ? profileState.cityName!
                    : (profileState.countryName?.trim().isNotEmpty ?? false)
                    ? profileState.countryName!
                    : S.of(context).kCairoEgypt)
              : S.of(context).kCairoEgypt;

          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => _refreshProfile(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // ── Profile Header (Avatar + Buttons) ──
                  ProfileHeaderSection(
                    logoBytes: logoBytes,
                    activePlanId: activePlanId,
                  ),
                  SizedBox(height: 20.h),

                  // ── Metrics Row (Rating, Users, Deliveries) ──
                  ProfileMetricsRow(
                    rating: rating,
                    followersCount: followersCount,
                    auctionsCount: auctionsCount,
                  ),
                  SizedBox(height: 24.h),

                  // ── User Info Fields — data from GET Auth/profile ──
                  ProfileInfoField(icon: Icons.person_outline, value: fullName),
                  SizedBox(height: 12.h),
                  ProfileInfoField(icon: Icons.email_outlined, value: email),
                  SizedBox(height: 12.h),
                  ProfileInfoField(
                    icon: Icons.phone_outlined,
                    value: phoneNumber,
                  ),
                  SizedBox(height: 12.h),

                  // ── Navigation Menu Items ──
                  ProfileMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: S.of(context).kWallet,
                    onTap: () {
                      Navigator.pushNamed(context, WalletView.routeName);
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    label: cityLabel,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.access_time,
                    label: S.of(context).kHistory,
                    onTap: () {
                      Navigator.pushNamed(context, HistoryView.routeName);
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.bar_chart_outlined,
                    label: S.of(context).kStatistics,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.star_outline,
                    label: S.of(context).kReviewsRatings,
                    onTap: () {
                      Navigator.pushNamed(context, ReviewsView.routeName);
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: S.of(context).kChangePassword,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChangePasswordView.routeName,
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    label: S.of(context).kChangeLanguage,
                    onTap: () {
                      _showLanguageSheet(context);
                    },
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    trailing: IgnorePointer(
                      child: Switch.adaptive(
                        value: _notificationsEnabled,
                        onChanged: (_) {},
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () => _toggleNotifications(!_notificationsEnabled),
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: S.of(context).kLogout,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      context.read<LogoutViewModel>().logout();
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  title: Text(S.of(context).kEnglish),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await getIt<CacheHelper>().saveData(
                      key: CacheKeys.language,
                      value: 'english',
                    );
                    if (context.mounted) {
                      SafqaSeller.of(context)?.setLocale(const Locale('en'));
                    }
                  },
                ),
                ListTile(
                  title: const Text('العربية'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await getIt<CacheHelper>().saveData(
                      key: CacheKeys.language,
                      value: 'arabic',
                    );
                    if (context.mounted) {
                      SafqaSeller.of(context)?.setLocale(const Locale('ar'));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
