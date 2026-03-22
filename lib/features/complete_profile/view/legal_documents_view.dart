import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/financial_details_view.dart';

/// Legal Documents screen – shown for Business Account after Store Information.
class LegalDocumentsView extends StatefulWidget {
  const LegalDocumentsView({super.key});
  static const String routeName = 'legalDocumentsView';

  @override
  State<LegalDocumentsView> createState() => _LegalDocumentsViewState();
}

class _LegalDocumentsViewState extends State<LegalDocumentsView> {
  bool _crUploaded = false;
  bool _taxIdUploaded = false;
  bool _nationalIdFrontUploaded = false;
  bool _nationalIdBackUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'Legal Documents'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                'Verify your business now to build buyer trust and boost your sales',
                style: TextStyles.regular14(context).copyWith(
                  color: const Color(0xFF444444),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              _DocumentTile(
                icon: Icons.description_outlined,
                label: 'Upload Commercial Registration (CR)',
                uploaded: _crUploaded,
                onTap: () => setState(() => _crUploaded = !_crUploaded),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.description_outlined,
                label: 'Upload Tax ID',
                uploaded: _taxIdUploaded,
                onTap: () =>
                    setState(() => _taxIdUploaded = !_taxIdUploaded),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.camera_alt_outlined,
                label: 'Upload Owner\'s National ID (Front)',
                uploaded: _nationalIdFrontUploaded,
                onTap: () => setState(
                    () => _nationalIdFrontUploaded = !_nationalIdFrontUploaded),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.camera_alt_outlined,
                label: 'Upload Owner\'s National ID (Back)',
                uploaded: _nationalIdBackUploaded,
                onTap: () => setState(
                    () => _nationalIdBackUploaded = !_nationalIdBackUploaded),
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, FinancialDetailsView.routeName);
                },
                text: 'Save & Continue',
                textColor: Colors.white,
                backgroundColor: AppColors.primaryColor,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.icon,
    required this.label,
    required this.uploaded,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: uploaded ? AppColors.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: uploaded
                ? AppColors.primaryColor
                : const Color(0xFFDDE3EE),
            width: uploaded ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                uploaded ? Icons.check_rounded : icon,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: TextStyles.medium15(context)
                    .copyWith(color: AppColors.primaryColor),
              ),
            ),
            if (uploaded)
              Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
