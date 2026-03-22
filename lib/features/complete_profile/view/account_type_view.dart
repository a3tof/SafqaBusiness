import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/identity_verification_view.dart';
import 'package:safqaseller/features/complete_profile/view/seller_information_view.dart';

class AccountTypeView extends StatefulWidget {
  const AccountTypeView({super.key});
  static const String routeName = 'accountTypeView';

  @override
  State<AccountTypeView> createState() => _AccountTypeViewState();
}

class _AccountTypeViewState extends State<AccountTypeView> {
  _AccountType? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'Account Type'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 32.h),
              _AccountTypeCard(
                type: _AccountType.personal,
                selected: _selected == _AccountType.personal,
                onTap: () => setState(() => _selected = _AccountType.personal),
              ),
              SizedBox(height: 16.h),
              _AccountTypeCard(
                type: _AccountType.business,
                selected: _selected == _AccountType.business,
                onTap: () => setState(() => _selected = _AccountType.business),
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  if (_selected == null) return;
                  if (_selected == _AccountType.personal) {
                    Navigator.pushNamed(
                      context,
                      SellerInformationView.routeName,
                      arguments: _AccountType.personal,
                    );
                  } else {
                    // Business: Identity Verification comes first
                    Navigator.pushNamed(
                      context,
                      IdentityVerificationView.routeName,
                      arguments: true, // isBusinessFlow
                    );
                  }
                },
                text: 'Continue',
                textColor: Colors.white,
                backgroundColor: _selected != null
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withValues(alpha: 0.5),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

enum _AccountType { personal, business }

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final _AccountType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPersonal = type == _AccountType.personal;
    final title = isPersonal ? 'Personal Account' : 'Business Account';
    final description = isPersonal
        ? 'Designed for individuals selling personal belongings and used items. (Requires National ID only)'
        : 'Designed for registered companies and verified stores. (Requires submitting official documents: Commercial Register & Tax ID)';
    final icon = isPersonal ? Icons.person_outline_rounded : Icons.business_outlined;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primaryColor : const Color(0xFFDDE3EE),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 32.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.semiBold16(context)
                        .copyWith(color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyles.regular14(context)
                        .copyWith(color: const Color(0xFF444444), height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
