import 'dart:io';
import 'package:safqaseller/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/financial_details_view.dart';

/// Legal Documents screen – shown for Business Account after Store Information.
/// Collects document files and passes them to the FinancialDetailsView.
class LegalDocumentsView extends StatefulWidget {
  const LegalDocumentsView({super.key});
  static const String routeName = 'legalDocumentsView';

  @override
  State<LegalDocumentsView> createState() => _LegalDocumentsViewState();
}

class _LegalDocumentsViewState extends State<LegalDocumentsView> {
  File? _crFile;
  File? _taxIdFile;
  File? _nationalIdFrontFile;
  File? _nationalIdBackFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile(void Function(File) onPicked) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => onPicked(File(image.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: S.of(context).kLegalDocuments),
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
                label: S.of(context).kUploadCommercialRe,
                uploaded: _crFile != null,
                onTap: () => _pickFile((f) => _crFile = f),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.description_outlined,
                label: S.of(context).kUploadTaxId,
                uploaded: _taxIdFile != null,
                onTap: () => _pickFile((f) => _taxIdFile = f),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.camera_alt_outlined,
                label: S.of(context).kUploadOwners,
                uploaded: _nationalIdFrontFile != null,
                onTap: () =>
                    _pickFile((f) => _nationalIdFrontFile = f),
              ),
              SizedBox(height: 12.h),
              _DocumentTile(
                icon: Icons.camera_alt_outlined,
                label: S.of(context).kUploadOwners,
                uploaded: _nationalIdBackFile != null,
                onTap: () =>
                    _pickFile((f) => _nationalIdBackFile = f),
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {
                  if (_crFile == null ||
                      _taxIdFile == null ||
                      _nationalIdFrontFile == null ||
                      _nationalIdBackFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(S.of(context).kPleaseUploadAllFo),
                        backgroundColor: Colors.red.shade600,
                      ),
                    );
                    return;
                  }
                  // Pass document files to FinancialDetailsView
                  Navigator.pushNamed(
                    context,
                    FinancialDetailsView.routeName,
                    arguments: LegalDocumentsArgs(
                      commercialRegister: _crFile!,
                      taxId: _taxIdFile!,
                      ownerNationalIdFront: _nationalIdFrontFile!,
                      ownerNationalIdBack: _nationalIdBackFile!,
                    ),
                  );
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

/// Arguments passed from LegalDocumentsView to FinancialDetailsView.
class LegalDocumentsArgs {
  final File commercialRegister;
  final File taxId;
  final File ownerNationalIdFront;
  final File ownerNationalIdBack;

  LegalDocumentsArgs({
    required this.commercialRegister,
    required this.taxId,
    required this.ownerNationalIdFront,
    required this.ownerNationalIdBack,
  });
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
                style: TextStyles.medium15(context).copyWith(
                  color: AppColors.primaryColor,
                ),
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
