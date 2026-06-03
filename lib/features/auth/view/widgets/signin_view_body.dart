import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/custom_text_field.dart';
import 'package:safqaseller/core/widgets/password_field.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreenView.routeName,
              (route) => false,
            );
          } else {
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
        final isTabletOrUp = Breakpoints.isTabletOrUp(context);
        final horizontalPadding = isTabletOrUp ? 24.r : kHorizontalPadding.sp;

        final forgotPasswordStyle = TextStyles.semiBold16(context).copyWith(
          fontSize: isTabletOrUp ? 18.0 : null,
          color: Theme.of(context).colorScheme.primary,
        );

        final primarySection = Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isTabletOrUp)
                ResponsiveFormRow(
                  leading: CustomTextFormField(
                    enabled: !isLoading,
                    onSaved: (value) => email = value!,
                    hintText: S.of(context).email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  trailing: PasswordField(
                    enabled: !isLoading,
                    hintText: S.of(context).password,
                    onSaved: (value) => password = value!,
                  ),
                )
              else ...[
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
              ],
              SizedBox(height: isTabletOrUp ? 16.0 : 16.sp),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ForgotPasswordView.routeName);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    S.of(context).forgotPassword,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: forgotPasswordStyle,
                  ),
                ),
              ),
              SizedBox(height: isTabletOrUp ? 28.0 : 33.sp),
                  state is LoginLoading
                      ? const CustomLoadingButton()
                      : CustomButton(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          context.read<LoginViewModel>().userLogin(
                                email: email,
                                password: password,
                              );
                        } else {
                          setState(() => autoValidateMode = AutovalidateMode.always);
                        }
                      },
                      text: S.of(context).signIn,
                    ),
            ],
          ),
        );

        final secondarySection = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DontHaveAnAccountWidet(),
            SizedBox(height: isTabletOrUp ? 24.0 : 33.sp),
            OrDivider(),
            SizedBox(height: isTabletOrUp ? 16.0 : 16.sp),
            if (isTabletOrUp)
              ResponsiveFormRow(
                leading: SocialLoginButton(
                  image: Assets.imagesGoogleIcon,
                  title: S.of(context).signInWithGoogle,
                  onPressed: () => context.read<LoginViewModel>().loginWithGoogle(),
                ),
                trailing: SocialLoginButton(
                  image: Assets.imagesFacebookIcon,
                  title: S.of(context).signInWithFacebook,
                  onPressed: () => context.read<LoginViewModel>().loginWithFacebook(),
                ),
              )
            else ...[
              SocialLoginButton(
                image: Assets.imagesGoogleIcon,
                title: S.of(context).signInWithGoogle,
                onPressed: () => context.read<LoginViewModel>().loginWithGoogle(),
              ),
              if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                SizedBox(height: 16.sp),
                SocialLoginButton(
                  image: Assets.imagesApplIcon,
                  title: S.of(context).signInWithApple,
                  onPressed: () {},
                ),
              ],
              SizedBox(height: 16.sp),
              SocialLoginButton(
                image: Assets.imagesFacebookIcon,
                title: S.of(context).signInWithFacebook,
                onPressed: () => context.read<LoginViewModel>().loginWithFacebook(),
              ),
            ],
          ],
        );

        final content = Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isTabletOrUp ? 24.0 : 24.sp),
                if (isTabletOrUp) ...[
                  ResponsiveFormSection(child: primarySection),
                  SizedBox(height: isTabletOrUp ? 20.0 : 20.sp),
                  ResponsiveFormSection(child: secondarySection),
                ] else ...[
                  primarySection,
                  SizedBox(height: 33.sp),
                  secondarySection,
                ],
              ],
            ),
          ),
        );

        return ResponsiveFormShell(
          enabled: isTabletOrUp,
          maxWidth: 700,
          child: content,
        );
      },
    );
  }
}
