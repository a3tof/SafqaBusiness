import 'dart:io';
import 'package:safqaseller/generated/l10n.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/complete_profile/view/store_information_view.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';
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

  Future<void> _pickImage(
    void Function(File) onPicked, {
    ImageSource source = ImageSource.gallery,
  }) async {
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
          backgroundColor: Theme.of(context).colorScheme.error,
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
              Navigator.pushNamed(context, StoreInformationView.routeName);
            } else {
              // Personal flow: mark profile complete and update role before navigating
              await getIt<ProfileViewModel>().completeProfile();
              await getIt<AuthViewModel>().setRole('Seller');
              getIt<HomeViewModel>().loadHomeData(force: true);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Your profile has been submitted for review!'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SellerLoading;
          final isTabletOrUp = Breakpoints.isTabletOrUp(context);

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: buildAppBar(
              context: context,
              title: S.of(context).kIdentityVerificatio,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w)),
                child: ResponsiveFormShell(
                  enabled: isTabletOrUp,
                  maxWidth: 700,
                  child: ResponsiveFormSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                    Text(
                      'To start selling, we need to confirm it\'s you',
                      style: TextStyles.regular16(context).copyWith(
                        color: Theme.of(context).hintColor,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                    _UploadTile(
                      icon: Icons.camera_alt_outlined,
                      label: S.of(context).kUploadNationalId,
                      uploaded: _idFrontFile != null,
                      onTap: () => _pickImage((f) => _idFrontFile = f),
                    ),
                    SizedBox(height: (isTabletOrUp ? 12.0 : 12.h)),
                    _UploadTile(
                      icon: Icons.camera_alt_outlined,
                      label: S.of(context).kUploadNationalId,
                      uploaded: _idBackFile != null,
                      onTap: () => _pickImage((f) => _idBackFile = f),
                    ),
                    SizedBox(height: (isTabletOrUp ? 12.0 : 12.h)),
                    _UploadTile(
                      icon: Icons.sentiment_satisfied_alt_outlined,
                      label: S.of(context).kTakeASelfieWithI,
                      uploaded: _selfieFile != null,
                      onTap: () => _pickImage(
                        (f) => _selfieFile = f,
                        source: ImageSource.camera,
                      ),
                    ),
                    SizedBox(height: (isTabletOrUp ? 32.0 : 32.h)),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: isTabletOrUp ? 54.0 : 54.h,
                            child: CustomButton(
                            onPressed: () {
                              _submit(context.read<SellerViewModel>());
                            },
                            text: widget.isBusinessFlow
                                ? 'Continue'
                                : 'Submit for Review',
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                            ),
                    SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                  ],
                ),
              ),
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
    final theme = Theme.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w), vertical: (isTabletOrUp ? 14.0 : 14.h)),
        decoration: BoxDecoration(
          color: uploaded ? theme.colorScheme.secondary : theme.cardColor,
          borderRadius: BorderRadius.circular(12.rSp(context)),
          border: Border.all(
            color: uploaded
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: uploaded ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: (isTabletOrUp ? 40.0 : 40.w),
              height: (isTabletOrUp ? 40.0 : 40.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                uploaded ? Icons.check_rounded : icon,
                color: theme.colorScheme.primary,
                size: 22.rSp(context),
              ),
            ),
            SizedBox(width: (isTabletOrUp ? 14.0 : 14.w)),
            Expanded(
              child: Text(
                label,
                style: TextStyles.medium15(
                  context,
                ).copyWith(color: theme.colorScheme.primary),
              ),
            ),
            if (uploaded)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 20.rSp(context),
              ),
          ],
        ),
      ),
    );
  }
}
