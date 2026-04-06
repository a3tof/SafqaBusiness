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
import 'package:safqaseller/features/complete_profile/view/identity_verification_view.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model_state.dart';
import 'package:safqaseller/features/auth/model/models/location_model.dart';
import 'package:safqaseller/features/auth/model/repositories/auth_repository.dart';
import 'package:safqaseller/core/widgets/location_picker_field.dart';

class SellerInformationView extends StatefulWidget {
  const SellerInformationView({super.key, this.accountType});
  static const String routeName = 'sellerInformationView';

  final Object? accountType;

  @override
  State<SellerInformationView> createState() => _SellerInformationViewState();
}

class _SellerInformationViewState extends State<SellerInformationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedPhoneCode = '+20';
  int _selectedBusinessType = 0; // 0 = Personal, 1 = Business

  File? _logoFile;

  static const List<Map<String, String>> _countries = [
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
  ];

  List<LocationModel> _apiCountries = [];
  List<LocationModel> _apiCities = [];
  LocationModel? _selectedLocationCountry;
  LocationModel? _selectedLocationCity;
  bool _isLoadingLocations = false;

  @override
  void initState() {
    super.initState();
    if (widget.accountType.toString().toLowerCase().contains('business')) {
      _selectedBusinessType = 1;
    }
    _loadApiCountries();
  }

  Future<void> _loadApiCountries() async {
    setState(() => _isLoadingLocations = true);
    try {
      _apiCountries = await getIt<AuthRepository>().getCountries();
    } catch (_) {}
    if (mounted) setState(() => _isLoadingLocations = false);
  }

  Future<void> _loadApiCities(int countryId) async {
    setState(() => _isLoadingLocations = true);
    _selectedLocationCity = null;
    _apiCities = [];
    try {
      _apiCities = await getIt<AuthRepository>().getCities(countryId);
    } catch (_) {}
    if (mounted) setState(() => _isLoadingLocations = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _logoFile = File(image.path));
    }
  }

  Future<void> _submit(SellerViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocationCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).kPleaseSelectACoun),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    MultipartFile? logo;
    if (_logoFile != null) {
      logo = await MultipartFile.fromFile(
        _logoFile!.path,
        filename: _logoFile!.path.split(Platform.pathSeparator).last,
      );
    }

    final phoneNumber = '$_selectedPhoneCode${_phoneController.text.trim()}';

    await viewModel.createSeller(
      storeName: _nameController.text.trim(),
      phoneNumber: phoneNumber,
      cityId: _selectedLocationCity!.id,
      businessType: _selectedBusinessType,
      description: _descController.text.trim(),
      logo: logo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SellerViewModel>(),
      child: BlocConsumer<SellerViewModel, SellerViewModelState>(
        listener: (context, state) {
          if (state is SellerCreated) {
            // Navigate to Identity Verification with sellerId
            Navigator.pushNamed(
              context,
              IdentityVerificationView.routeName,
              arguments: _selectedBusinessType == 1, // isBusinessFlow
            );
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
            appBar:
                buildAppBar(context: context, title: S.of(context).kSellerInformation),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      // Name field
                      _FieldLabel(label: S.of(context).kStoreName),
                      SizedBox(height: 6.h),
                      _InputField(
                        controller: _nameController,
                        hint: 'Store Name',
                        keyboardType: TextInputType.name,
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Store name is required'
                                : null,
                      ),
                      SizedBox(height: 16.h),

                      // Phone number field
                      _FieldLabel(label: S.of(context).kPhoneNumber),
                      SizedBox(height: 6.h),
                      _PhoneField(
                        phoneController: _phoneController,
                        countries: _countries,
                        selectedCode: _selectedPhoneCode,
                        onCodeChanged: (code) =>
                            setState(() => _selectedPhoneCode = code),
                      ),
                      SizedBox(height: 16.h),

                      // Country
                      _FieldLabel(label: S.of(context).kCountry),
                      SizedBox(height: 6.h),
                      LocationPickerField(
                        enabled: !_isLoadingLocations && _apiCountries.isNotEmpty,
                        hintText: S.of(context).kSelectCountry,
                        locations: _apiCountries,
                        selectedLocation: _selectedLocationCountry,
                        onChanged: (location) {
                          setState(() => _selectedLocationCountry = location);
                          if (location != null) _loadApiCities(location.id);
                        },
                      ),
                      SizedBox(height: 16.h),

                      // City
                      _FieldLabel(label: S.of(context).kCity),
                      SizedBox(height: 6.h),
                      LocationPickerField(
                        enabled: !_isLoadingLocations && _apiCities.isNotEmpty,
                        hintText: S.of(context).kSelectCity,
                        locations: _apiCities,
                        selectedLocation: _selectedLocationCity,
                        onChanged: (location) => setState(() => _selectedLocationCity = location),
                      ),
                      SizedBox(height: 16.h),

                      // Logo
                      _FieldLabel(label: S.of(context).kLogoOptional),
                      SizedBox(height: 6.h),
                      _ImagePickerBox(
                        file: _logoFile,
                        onTap: _pickLogo,
                      ),
                      SizedBox(height: 16.h),

                      // Description
                      _FieldLabel(label: S.of(context).kDescription),
                      SizedBox(height: 6.h),
                      _DescriptionField(
                        controller: _descController,
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Description is required'
                                : null,
                      ),
                      SizedBox(height: 32.h),

                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : CustomButton(
                              onPressed: () {
                                _submit(
                                    context.read<SellerViewModel>());
                              },
                              text: 'Save & Continue',
                              textColor: Colors.white,
                              backgroundColor: AppColors.primaryColor,
                            ),
                      SizedBox(height: 16.h),
                    ],
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

/// ── Supporting widgets ─────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.semiBold16(context).copyWith(
        color: AppColors.primaryColor,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyles.regular14(context).copyWith(color: Colors.black87),
      decoration: _inputDecoration(hint),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.phoneController,
    required this.countries,
    required this.selectedCode,
    required this.onCodeChanged,
  });

  final TextEditingController phoneController;
  final List<Map<String, String>> countries;
  final String selectedCode;
  final ValueChanged<String> onCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE3EE)),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              icon:
                  Icon(Icons.arrow_drop_down, size: 18.sp, color: Colors.grey),
              items: countries.map((c) {
                return DropdownMenuItem<String>(
                  value: c['code'],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c['flag']!, style: TextStyle(fontSize: 18.sp)),
                      SizedBox(width: 4.w),
                      Text(
                        c['code']!,
                        style: TextStyles.regular13(context)
                            .copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onCodeChanged(v);
              },
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Phone number is required' : null,
            style:
                TextStyles.regular14(context).copyWith(color: Colors.black87),
            decoration: _inputDecoration('Phone Number'),
          ),
        ),
      ],
    );
  }
}



class _ImagePickerBox extends StatelessWidget {
  const _ImagePickerBox({this.file, required this.onTap});

  final File? file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: file != null
                ? AppColors.primaryColor
                : const Color(0xFFDDE3EE),
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: file != null ? AppColors.secondaryColor : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (file != null) ...[
              Icon(Icons.check_circle_rounded,
                  size: 18.sp, color: Colors.green),
              SizedBox(width: 6.w),
              Text(
                'Image selected',
                style: TextStyles.regular14(context)
                    .copyWith(color: AppColors.primaryColor),
              ),
            ] else ...[
              Text(
                'Add Image ',
                style: TextStyles.regular14(context)
                    .copyWith(color: const Color(0xFF999999)),
              ),
              Icon(Icons.add, size: 18.sp, color: const Color(0xFF999999)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DescriptionField extends StatefulWidget {
  const _DescriptionField({required this.controller, this.validator});
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  int _charCount = 0;
  static const int _maxChars = 50;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() => _charCount = widget.controller.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          maxLength: _maxChars,
          maxLines: 4,
          minLines: 4,
          validator: widget.validator,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  const SizedBox.shrink(),
          style: TextStyles.regular14(context).copyWith(color: Colors.black87),
          decoration: _inputDecoration('').copyWith(
            contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 28.h),
          ),
        ),
        Positioned(
          bottom: 8.h,
          right: 10.w,
          child: Text(
            '$_charCount/$_maxChars',
            style: TextStyles.regular12(context)
                .copyWith(color: const Color(0xFF999999)),
          ),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xFF999999),
      fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3EE)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF023E8A), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}
