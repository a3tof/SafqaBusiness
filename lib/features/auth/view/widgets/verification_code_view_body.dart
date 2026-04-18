import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/custom_pin_box.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/create_password_view.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/confirm_email/confirm_email_view_model.dart';
import 'package:safqaseller/features/auth/view_model/confirm_email/confirm_email_view_model_state.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model_state.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class VerificationCodeViewBody extends StatefulWidget {
  const VerificationCodeViewBody({super.key, required this.args});

  final VerificationCodeArgs args;

  @override
  State<VerificationCodeViewBody> createState() =>
      _VerificationCodeViewBodyState();
}

class _VerificationCodeViewBodyState extends State<VerificationCodeViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  static const int _digitCount = 6;
  static const double _boxSpacing = 8.0;

  final List<TextEditingController> _controllers =
      List.generate(_digitCount, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_digitCount, (_) => FocusNode());

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _digitCount; i++) {
      final index = i;
      _focusNodes[index].onKeyEvent = (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[index].text.isEmpty &&
            index > 0) {
          _focusNodes[index - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidateMode = AutovalidateMode.always);
      return;
    }

    if (widget.args.flow == VerificationFlow.registration) {
      context.read<ConfirmEmailViewModel>().confirmEmail(
            email: widget.args.email,
            otp: _otp,
            password: widget.args.password,
          );
    } else {
      context.read<ForgotPasswordViewModel>().verifyOtp(
            email: widget.args.email,
            code: _otp,
          );
    }
  }

  void _resend() {
    if (widget.args.flow == VerificationFlow.registration) {
      context.read<ConfirmEmailViewModel>().resendOtp(widget.args.email);
    } else {
      context.read<ForgotPasswordViewModel>().resendOtp(widget.args.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.args.flow == VerificationFlow.registration) {
      return BlocConsumer<ConfirmEmailViewModel, ConfirmEmailState>(
        listener: _confirmEmailListener,
        builder: (context, state) =>
            _buildBody(isLoading: state is ConfirmEmailLoading),
      );
    } else {
      return BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
        listener: _forgotPasswordListener,
        builder: (context, state) =>
            _buildBody(isLoading: state is ForgotPasswordLoading),
      );
    }
  }

  void _confirmEmailListener(BuildContext context, ConfirmEmailState state) {
    if (state is ConfirmEmailAutoLoginSuccess) {
      unawaited(_navigateAfterAutoLogin(context));
    } else if (state is ConfirmEmailSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).emailConfirmedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreenView.routeName,
        (route) => false,
      );
    } else if (state is ConfirmEmailOtpResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).otpResentSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    } else if (state is ConfirmEmailError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyOtpError(context, state.message)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateAfterAutoLogin(BuildContext context) async {
    // loginUser() persisted the session in cache; sync the in-memory auth cubit
    // before opening Home so the complete-profile dialog condition can pass.
    await getIt<AuthViewModel>().onLoginSuccess();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).emailConfirmedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeScreenView.routeName,
      (route) => false,
      arguments: {'showCompleteProfile': true},
    );
  }

  void _forgotPasswordListener(
    BuildContext context,
    ForgotPasswordState state,
  ) {
    if (state is ForgotPasswordOtpVerified) {
      Navigator.pushNamed(
        context,
        CreatePasswordView.routeName,
        arguments: CreatePasswordArgs(
          email: state.email,
          token: state.token,
          forgotPasswordViewModel:
              widget.args.forgotPasswordViewModel ??
              context.read<ForgotPasswordViewModel>(),
        ),
      );
    } else if (state is ForgotPasswordOtpResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).otpResentSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    } else if (state is ForgotPasswordError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyOtpError(context, state.message)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Maps raw server OTP error messages to localized user-friendly strings.
  String _friendlyOtpError(BuildContext context, String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('expired') || lower.contains('exp')) {
      return S.of(context).otpExpired;
    }
    if (lower.contains('invalid') ||
        lower.contains('incorrect') ||
        lower.contains('wrong') ||
        lower.contains('not valid') ||
        lower.contains('otp')) {
      return S.of(context).invalidOtp;
    }
    return raw;
  }

  Widget _buildBody({required bool isLoading}) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding.sp),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.sp),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: Text(
                    S.of(context).verificationCodeDescription,
                    textAlign: TextAlign.center,
                    style: TextStyles.regular14(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 32.sp),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double boxSize =
                          (constraints.maxWidth -
                                  (_digitCount - 1) * _boxSpacing) /
                              _digitCount;
                      return Row(
                        children: List.generate(
                          _digitCount,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              right:
                                  index < _digitCount - 1 ? _boxSpacing : 0,
                            ),
                            child: CustomPinBox(
                              size: boxSize,
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    index < _digitCount - 1) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) return '';
                                return null;
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 32.sp),
                isLoading
                    ? const CustomLoadingButton()
                    : CustomButton(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onPressed: _submit,
                        text: S.of(context).verify,
                      ),
                SizedBox(height: 24.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).dontReceiveCode,
                      style: TextStyles.regular14(context)
                          .copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                    ),
                    SizedBox(width: 4.sp),
                    GestureDetector(
                      onTap: _resend,
                      child: Text(
                        S.of(context).resend,
                        style: TextStyles.semiBold14(context)
                            .copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
