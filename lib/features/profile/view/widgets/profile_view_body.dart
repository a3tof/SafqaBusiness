import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/auth/view_model/logout/logout_view_model.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_header_section.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_info_field.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_menu_item.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_metrics_row.dart';
import 'package:safqaseller/features/wallet/view/wallet_view.dart';
import 'package:safqaseller/main.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // ── Profile Header (Avatar + Buttons) ──
            const ProfileHeaderSection(),
            SizedBox(height: 20.h),

            // ── Metrics Row (Rating, Users, Deliveries) ──
            const ProfileMetricsRow(),
            SizedBox(height: 24.h),

            // ── User Info Fields ──
            const ProfileInfoField(
              icon: Icons.person_outline,
              value: 'Saeed Ahmed',
            ),
            SizedBox(height: 12.h),
            const ProfileInfoField(
              icon: Icons.email_outlined,
              value: 'saeed.ahmed@gmail.com',
            ),
            SizedBox(height: 12.h),
            const ProfileInfoField(
              icon: Icons.phone_outlined,
              value: '01000000000',
            ),
            SizedBox(height: 12.h),

            // ── Navigation Menu Items ──
            ProfileMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Wallet',
              onTap: () {
                Navigator.pushNamed(context, WalletView.routeName);
              },
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              label: 'Cairo, Egypt',
              trailingIcon: Icons.keyboard_arrow_down,
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.access_time,
              label: 'History',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.bar_chart_outlined,
              label: 'Statistics',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.star_outline,
              label: 'Reviews & Ratings',
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.language_outlined,
              label: 'Change Language',
              onTap: () {
                _showLanguageSheet(context);
              },
            ),
            SizedBox(height: 12.h),
            ProfileMenuItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
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
                  title: const Text('English'),
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
