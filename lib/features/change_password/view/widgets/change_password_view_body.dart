import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/password_field.dart';
import 'package:safqaseller/features/change_password/model/models/change_password_models.dart';
import 'package:safqaseller/features/change_password/view_model/change_password/change_password_view_model.dart';
import 'package:safqaseller/features/change_password/view_model/change_password/change_password_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({super.key});

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).kPasswordChanged)),
          );
          Navigator.pop(context);
        } else if (state is ChangePasswordError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;
        final isTabletOrUp = Breakpoints.isTabletOrUp(context);

        return SafeArea(
          child: SingleChildScrollView(
            padding: isTabletOrUp 
                ? const EdgeInsets.symmetric(vertical: 24.0) 
                : EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: ResponsiveFormShell(
              enabled: isTabletOrUp,
              maxWidth: 700,
              child: ResponsiveFormSection(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: S.of(context).kCurrentPassword),
                      SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                      PasswordField(
                        controller: _currentPasswordController,
                        hintText: '',
                        enabled: !isLoading,
                        validator: _validateCurrentPassword,
                      ),
                      SizedBox(height: isTabletOrUp ? 24.0 : 24.h),
                      if (isTabletOrUp)
                        ResponsiveFormRow(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(text: S.of(context).kNewPassword),
                              SizedBox(height: 10.0),
                              PasswordField(
                                controller: _newPasswordController,
                                hintText: '',
                                enabled: !isLoading,
                                validator: _validateNewPassword,
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(text: S.of(context).kConfirmPassword),
                              SizedBox(height: 10.0),
                              PasswordField(
                                controller: _confirmPasswordController,
                                hintText: '',
                                enabled: !isLoading,
                                validator: _validateConfirmPassword,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        _FieldLabel(text: S.of(context).kNewPassword),
                        SizedBox(height: 10.h),
                        PasswordField(
                          controller: _newPasswordController,
                          hintText: '',
                          enabled: !isLoading,
                          validator: _validateNewPassword,
                        ),
                        SizedBox(height: 24.h),
                        _FieldLabel(text: S.of(context).kConfirmPassword),
                        SizedBox(height: 10.h),
                        PasswordField(
                          controller: _confirmPasswordController,
                          hintText: '',
                          enabled: !isLoading,
                          validator: _validateConfirmPassword,
                        ),
                      ],
                      SizedBox(height: isTabletOrUp ? 36.0 : 36.h),
                      isLoading
                          ? const CustomLoadingButton()
                          : CustomButton(
                              onPressed: _submit,
                              text: S.of(context).kChangePassword,
                              textColor: Colors.white,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).fieldRequired;
    }
    if (value.length < 8) {
      return S.of(context).kPasswordTooShort;
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).fieldRequired;
    }
    if (value.length < 8) {
      return S.of(context).kPasswordTooShort;
    }
    if (value == _currentPasswordController.text) {
      return S.of(context).kPasswordSameAsCurrent;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).fieldRequired;
    }
    if (value.length < 8) {
      return S.of(context).kPasswordTooShort;
    }
    if (value != _newPasswordController.text) {
      return S.of(context).kPasswordMismatch;
    }
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    context.read<ChangePasswordViewModel>().changePassword(
      ChangePasswordRequest(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.semiBold16(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }
}
