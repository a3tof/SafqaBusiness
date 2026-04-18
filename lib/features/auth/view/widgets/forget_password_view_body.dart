import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/custom_text_field.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/verification_code_view.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordOtpSent) {
          Navigator.pushNamed(
            context,
            VerificationCodeView.routeName,
            arguments: VerificationCodeArgs(
              email: state.email,
              flow: VerificationFlow.forgotPassword,
              // Thread the same VM instance into the next screens.
              forgotPasswordViewModel:
                  context.read<ForgotPasswordViewModel>(),
            ),
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
                autovalidateMode: _autoValidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.sp),
                    Text(
                      S.of(context).forgetPasswordDescription,
                      style: TextStyles.regular16(context).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32.sp),
                    Text(
                      S.of(context).email,
                      style: TextStyles.semiBold16(context),
                    ),
                    SizedBox(height: 8.sp),
                    CustomTextFormField(
                      onSaved: (value) => _email = value!,
                      hintText: '',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 32.sp),
                    isLoading
                        ? const CustomLoadingButton()
                        : CustomButton(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                context
                                    .read<ForgotPasswordViewModel>()
                                    .requestOtp(_email);
                              } else {
                                setState(() => _autoValidateMode =
                                    AutovalidateMode.always);
                              }
                            },
                            text: S.of(context).sendCode,
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
