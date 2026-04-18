import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/custom_text_field.dart';
import 'package:safqaseller/core/widgets/password_field.dart';
import 'package:safqaseller/features/auth/view/forget_password_view.dart';
import 'package:safqaseller/features/auth/view/widgets/dont_have_an_account_widget.dart';
import 'package:safqaseller/features/auth/view/widgets/or_divider.dart';
import 'package:safqaseller/features/auth/view/widgets/social_login_button.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/login/login_view_model.dart';
import 'package:safqaseller/features/auth/view_model/login/login_view_model_state.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginViewModel, LoginState>(
      listener: (context, state) async {
        if (kDebugMode) print('UI State Changed: ${state.runtimeType}');

        if (state is LoginSuccess) {
          // Trigger AuthViewModel to set initial auth state
          final authVM = getIt<AuthViewModel>();
          await authVM.onLoginSuccess();

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).kLoginSuccessful),
              backgroundColor: Colors.green,
            ),
          );

          if (state.isSeller) {
            // ── Seller: go directly to HomeScreen ─────────────────────────
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreenView.routeName,
              (route) => false,
            );
          } else {
            // ── "Login successful As User": navigate with an explicit flag
            //    so the home screen can show the complete-profile dialog. ──
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreenView.routeName,
              (route) => false,
              arguments: {'showCompleteProfile': true},
            );
          }
        } else if (state is LoginError) {
          if (kDebugMode) print('UI: Login failed — ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding.sp),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: formKey,
              autovalidateMode: autoValidateMode,
              child: Column(
                children: [
                  SizedBox(height: 24.sp),
                  CustomTextFormField(
                    enabled: !isLoading,
                    onSaved: (value) => email = value!,
                    hintText: S.of(context).email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.sp),
                  PasswordField(
                    enabled: !isLoading,
                    hintText: S.of(context).password,
                    onSaved: (value) => password = value!,
                  ),
                  SizedBox(height: 16.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ForgotPasswordView.routeName,
                        ),
                        child: Text(
                          S.of(context).forgotPassword,
                          style: TextStyles.semiBold16(context)
                              .copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 33.sp),
                  isLoading
                      ? const CustomLoadingButton()
                      : CustomButton(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white,
                          text: S.of(context).signIn,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              context.read<LoginViewModel>().userLogin(
                                    email: email,
                                    password: password,
                                  );
                            } else {
                              setState(() => autoValidateMode =
                                  AutovalidateMode.always);
                            }
                          },
                        ),
                  SizedBox(height: 33.sp),
                  DontHaveAnAccountWidet(),
                  SizedBox(height: 33.sp),
                  OrDivider(),
                  SizedBox(height: 16.sp),
                  SocialLoginButton(
                    image: Assets.imagesGoogleIcon,
                    title: S.of(context).signInWithGoogle,
                    onPressed: () =>
                        context.read<LoginViewModel>().loginWithGoogle(),
                  ),
                  SizedBox(height: 16.sp),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    Column(
                      children: [
                        SocialLoginButton(
                          image: Assets.imagesApplIcon,
                          title: S.of(context).signInWithApple,
                          onPressed: () {},
                        ),
                        SizedBox(height: 16.sp),
                      ],
                    ),
                  SocialLoginButton(
                    image: Assets.imagesFacebookIcon,
                    title: S.of(context).signInWithFacebook,
                    onPressed: () =>
                        context.read<LoginViewModel>().loginWithFacebook(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
