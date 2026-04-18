import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/password_field.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class CreatePasswordViewBody extends StatefulWidget {
  const CreatePasswordViewBody({super.key, required this.args});

  final CreatePasswordArgs args;

  @override
  State<CreatePasswordViewBody> createState() => _CreatePasswordViewBodyState();
}

class _CreatePasswordViewBodyState extends State<CreatePasswordViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  late String _newPassword;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).passwordResetSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            SigninView.routeName,
            (route) => false,
          );
        } else if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding.sp),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16.sp),
                    Text(
                      S.of(context).createPasswordDescription,
                      style: TextStyles.regular14(context).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.sp),
                    PasswordField(
                      enabled: !isLoading,
                      controller: _passwordController,
                      hintText: S.of(context).newPassword,
                      onSaved: (value) => _newPassword = value ?? '',
                    ),
                    SizedBox(height: 32.sp),
                    PasswordField(
                      enabled: !isLoading,
                      hintText: S.of(context).confirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).fieldRequired;
                        }
                        if (value != _passwordController.text) {
                          return S.of(context).passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.sp),
                    isLoading
                        ? const CustomLoadingButton()
                        : CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                context
                                    .read<ForgotPasswordViewModel>()
                                    .resetPassword(
                                      email: widget.args.email,
                                      token: widget.args.token,
                                      newPassword: _newPassword,
                                    );
                              }
                            },
                            text: S.of(context).createPassword,
                            textColor: Colors.white,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
