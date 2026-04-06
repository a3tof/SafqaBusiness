import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/core/widgets/custom_loading_button.dart';
import 'package:safqaseller/core/widgets/custom_text_field.dart';
import 'package:safqaseller/core/widgets/date_picker_field.dart';
import 'package:safqaseller/core/widgets/gender_picker_field.dart';
import 'package:safqaseller/core/widgets/password_field.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/verification_code_view.dart';
import 'package:safqaseller/features/auth/view/widgets/have_an_account_widget.dart';
import 'package:safqaseller/features/auth/view/widgets/terms_and_conditions.dart';
import 'package:safqaseller/features/auth/view_model/register/register_view_model.dart';
import 'package:safqaseller/features/auth/view_model/register/register_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:safqaseller/core/widgets/location_picker_field.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, userName, password, phoneNumber;
  String? birthdate;
  String? gender;
  bool isTermsAccepted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<RegisterViewModel>();
      if (viewModel.countries.isEmpty) {
        viewModel.loadCountries();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterViewModel, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessEmailSent) {
          final msg = state.message.isNotEmpty
              ? state.message
              : S.of(context).otpSentToEmail;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: const Color(0xFF1A3A6B),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushNamed(
            context,
            VerificationCodeView.routeName,
            arguments: VerificationCodeArgs(
              email: state.email,
              password: state.password,
              flow: VerificationFlow.registration,
            ),
          );
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding.sp),
            child: Form(
              key: formKey,
              autovalidateMode: autoValidateMode,
              child: Column(
                children: [
                  SizedBox(height: 24.sp),
                  CustomTextFormField(
                    enabled: !isLoading,
                    onSaved: (value) => userName = value!,
                    hintText: S.of(context).fullName,
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 16.sp),
                  CustomTextFormField(
                    enabled: !isLoading,
                    onSaved: (value) => email = value!,
                    hintText: S.of(context).email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.sp),
                  CustomTextFormField(
                    enabled: !isLoading,
                    onSaved: (value) => phoneNumber = value!,
                    hintText: S.of(context).phoneNumber,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: 16.sp),
                  DatePickerField(
                    enabled: !isLoading,
                    hintText: S.of(context).birthdate,
                    onSaved: (value) => birthdate = value,
                  ),
                  SizedBox(height: 16.sp),
                  LocationPickerField(
                    enabled: !isLoading && context.read<RegisterViewModel>().countries.isNotEmpty,
                    hintText: S.of(context).kCountry,
                    locations: context.read<RegisterViewModel>().countries,
                    selectedLocation: context.read<RegisterViewModel>().selectedCountry,
                    onChanged: (location) {
                      context.read<RegisterViewModel>().selectedCountry = location;
                      if (location != null) {
                        context.read<RegisterViewModel>().loadCities(location.id);
                      }
                    },
                  ),
                  SizedBox(height: 16.sp),
                  LocationPickerField(
                    enabled: !isLoading && context.read<RegisterViewModel>().cities.isNotEmpty,
                    hintText: S.of(context).kCity,
                    locations: context.read<RegisterViewModel>().cities,
                    selectedLocation: context.read<RegisterViewModel>().selectedCity,
                    onChanged: (location) => context.read<RegisterViewModel>().selectedCity = location,
                  ),
                  SizedBox(height: 16.sp),
                  GenderPickerField(
                    enabled: !isLoading,
                    hintText: S.of(context).gender,
                    maleText: S.of(context).male,
                    femaleText: S.of(context).female,
                    onSaved: (value) => gender = value,
                  ),
                  SizedBox(height: 16.sp),
                  PasswordField(
                    enabled: !isLoading,
                    controller: _passwordController,
                    hintText: S.of(context).password,
                    onSaved: (value) => password = value!,
                  ),
                  SizedBox(height: 16.sp),
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
                  SizedBox(height: 16.sp),
                  TermsAndConditions(
                    onChanged: (value) => isTermsAccepted = value,
                  ),
                  SizedBox(height: 30.sp),
                  isLoading
                      ? const CustomLoadingButton()
                      : CustomButton(
                          backgroundColor: AppColors.lightPrimaryColor,
                          textColor: AppColors.secondaryColor,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              if (!isTermsAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please accept terms and conditions',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (birthdate == null || gender == null || context.read<RegisterViewModel>().selectedCity == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S.of(context).kPleaseFillAllFiel),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Convert gender string to int (0 = male, 1 = female)
                              final genderInt = gender == 'male' ? 0 : 1;

                              context.read<RegisterViewModel>().userRegister(
                                    fullName: userName,
                                    email: email,
                                    password: password,
                                    birthDate: birthdate!,
                                    gender: genderInt,
                                    cityId: context.read<RegisterViewModel>().selectedCity!.id,
                                    phoneNumber: phoneNumber,
                                  );
                            } else {
                              setState(() => autoValidateMode =
                                  AutovalidateMode.always);
                            }
                          },
                          text: S.of(context).signUp,
                        ),
                  SizedBox(height: 26.sp),
                  HaveAnAccountWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
