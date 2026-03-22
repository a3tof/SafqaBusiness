import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/store_information_view.dart';

class IdentityVerificationView extends StatefulWidget {
  const IdentityVerificationView({super.key, this.isBusinessFlow = false});
  static const String routeName = 'identityVerificationView';

  final bool isBusinessFlow;

  @override
  State<IdentityVerificationView> createState() =>
      _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> {
  bool _idFrontUploaded = false;
  bool _idBackUploaded = false;
  bool _selfieUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'Identity Verification'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                'To start selling, we need to confirm it\'s you',
                style: TextStyles.regular16(context)
                    .copyWith(color: const Color(0xFF444444), height: 1.5),
              ),
              SizedBox(height: 24.h),
              _UploadTile(
                icon: Icons.camera_alt_outlined,
                label: 'Upload National ID (Front)',
                uploaded: _idFrontUploaded,
                onTap: () {
                  // TODO: implement image picker
                  setState(() => _idFrontUploaded = !_idFrontUploaded);
                },
              ),
              SizedBox(height: 12.h),
              _UploadTile(
                icon: Icons.camera_alt_outlined,
                label: 'Upload National ID (Back)',
                uploaded: _idBackUploaded,
                onTap: () {
                  setState(() => _idBackUploaded = !_idBackUploaded);
                },
              ),
              SizedBox(height: 12.h),
              _UploadTile(
                icon: Icons.sentiment_satisfied_alt_outlined,
                label: 'Take a Selfie with ID',
                uploaded: _selfieUploaded,
                onTap: () {
                  setState(() => _selfieUploaded = !_selfieUploaded);
                },
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  if (widget.isBusinessFlow) {
                    Navigator.pushNamed(
                      context,
                      StoreInformationView.routeName,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Your profile has been submitted for review!',
                        ),
                        backgroundColor: Color(0xFF023E8A),
                      ),
                    );
                  }
                },
                text: widget.isBusinessFlow ? 'Continue' : 'Submit for Review',
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

class _UploadTile extends StatelessWidget {
  const _UploadTile({
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
                style: TextStyles.medium15(context).copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            if (uploaded)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
