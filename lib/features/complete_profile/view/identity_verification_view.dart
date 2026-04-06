import 'dart:io';
import 'package:safqaseller/generated/l10n.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/complete_profile/view/store_information_view.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model_state.dart';

class IdentityVerificationView extends StatefulWidget {
  const IdentityVerificationView({super.key, this.isBusinessFlow = false});
  static const String routeName = 'identityVerificationView';

  final bool isBusinessFlow;

  @override
  State<IdentityVerificationView> createState() =>
      _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> {
  File? _idFrontFile;
  File? _idBackFile;
  File? _selfieFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(void Function(File) onPicked,
      {ImageSource source = ImageSource.gallery}) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => onPicked(File(image.path)));
    }
  }

  Future<void> _submit(SellerViewModel viewModel) async {
    if (_idFrontFile == null || _idBackFile == null || _selfieFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).kPleaseUploadAllTh),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    final nationalIdFront = await MultipartFile.fromFile(
      _idFrontFile!.path,
      filename: 'national_id_front.jpg',
    );
    final nationalIdBack = await MultipartFile.fromFile(
      _idBackFile!.path,
      filename: 'national_id_back.jpg',
    );
    final selfieWithId = await MultipartFile.fromFile(
      _selfieFile!.path,
      filename: 'selfie_with_id.jpg',
    );

    await viewModel.uploadPersonalVerification(
      nationalIdFront: nationalIdFront,
      nationalIdBack: nationalIdBack,
      selfieWithId: selfieWithId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SellerViewModel>(),
      child: BlocConsumer<SellerViewModel, SellerViewModelState>(
        listener: (context, state) async {
          if (state is PersonalVerificationSuccess) {
            if (widget.isBusinessFlow) {
              // Business flow: continue to Store Information
              Navigator.pushNamed(
                context,
                StoreInformationView.routeName,
              );
            } else {
              // Personal flow: mark profile complete and update role before navigating
              await getIt<ProfileViewModel>().completeProfile();
              await getIt<AuthViewModel>().setRole('Seller');

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Your profile has been submitted for review!',
                  ),
                  backgroundColor: Color(0xFF023E8A),
                ),
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreenView.routeName,
                (route) => false,
              );
            }
          } else if (state is SellerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SellerLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(
                context: context, title: S.of(context).kIdentityVerificatio),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      'To start selling, we need to confirm it\'s you',
                      style: TextStyles.regular16(context).copyWith(
                          color: const Color(0xFF444444), height: 1.5),
                    ),
                    SizedBox(height: 24.h),
                    _UploadTile(
                      icon: Icons.camera_alt_outlined,
                      label: S.of(context).kUploadNationalId,
                      uploaded: _idFrontFile != null,
                      onTap: () =>
                          _pickImage((f) => _idFrontFile = f),
                    ),
                    SizedBox(height: 12.h),
                    _UploadTile(
                      icon: Icons.camera_alt_outlined,
                      label: S.of(context).kUploadNationalId,
                      uploaded: _idBackFile != null,
                      onTap: () =>
                          _pickImage((f) => _idBackFile = f),
                    ),
                    SizedBox(height: 12.h),
                    _UploadTile(
                      icon: Icons.sentiment_satisfied_alt_outlined,
                      label: S.of(context).kTakeASelfieWithI,
                      uploaded: _selfieFile != null,
                      onTap: () => _pickImage(
                        (f) => _selfieFile = f,
                        source: ImageSource.camera,
                      ),
                    ),
                    const Spacer(),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : CustomButton(
                            onPressed: () {
                              _submit(context.read<SellerViewModel>());
                            },
                            text: widget.isBusinessFlow
                                ? 'Continue'
                                : 'Submit for Review',
                            textColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                          ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
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
