import 'dart:io';
import 'package:safqaseller/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/identity_verification_view.dart';
import 'package:safqaseller/features/complete_profile/view/legal_documents_view.dart';
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
  int _selectedBusinessType = 1; // 1 = Personal, 2 = Business

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
      _selectedBusinessType = 2;
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
          backgroundColor: Theme.of(context).colorScheme.error,
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BlocProvider(
      create: (_) => getIt<SellerViewModel>(),
      child: BlocConsumer<SellerViewModel, SellerViewModelState>(
        listener: (context, state) {
          if (state is SellerCreated) {
            if (_selectedBusinessType == 2) {
              Navigator.pushNamed(context, LegalDocumentsView.routeName);
            } else {
              Navigator.pushNamed(
                context,
                IdentityVerificationView.routeName,
                arguments: false,
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

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: buildAppBar(
              context: context,
              title: S.of(context).kSellerInformation,
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: (isTabletOrUp ? 16.0 : 16.w),
                    vertical: (isTabletOrUp ? 12.0 : 12.h),
                  ),
                  child: ResponsiveFormShell(
                    enabled: isTabletOrUp,
                    maxWidth: 700,
                    child: ResponsiveFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: (isTabletOrUp ? 8.0 : 8.h)),
                          ResponsiveFormRow(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name field
                                _FieldLabel(label: S.of(context).kStoreName),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _InputField(
                                  controller: _nameController,
                                  hint: 'Store Name',
                                  keyboardType: TextInputType.name,
                                  validator: (v) => v == null || v.trim().isEmpty
                                      ? 'Store name is required'
                                      : null,
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Phone number field
                                _FieldLabel(label: S.of(context).kPhoneNumber),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _PhoneField(
                                  phoneController: _phoneController,
                                  countries: _countries,
                                  selectedCode: _selectedPhoneCode,
                                  onCodeChanged: (code) =>
                                      setState(() => _selectedPhoneCode = code),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                          ResponsiveFormRow(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Country
                                _FieldLabel(label: S.of(context).kCountry),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                LocationPickerField(
                                  enabled:
                                      !_isLoadingLocations && _apiCountries.isNotEmpty,
                                  hintText: S.of(context).kSelectCountry,
                                  locations: _apiCountries,
                                  selectedLocation: _selectedLocationCountry,
                                  onChanged: (location) {
                                    setState(() => _selectedLocationCountry = location);
                                    if (location != null) _loadApiCities(location.id);
                                  },
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // City
                                _FieldLabel(label: S.of(context).kCity),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                LocationPickerField(
                                  enabled: !_isLoadingLocations && _apiCities.isNotEmpty,
                                  hintText: S.of(context).kSelectCity,
                                  locations: _apiCities,
                                  selectedLocation: _selectedLocationCity,
                                  onChanged: (location) =>
                                      setState(() => _selectedLocationCity = location),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                      // Logo
                      _FieldLabel(label: S.of(context).kLogoOptional),
                      SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                      _ImagePickerBox(file: _logoFile, onTap: _pickLogo),
                      SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                      // Description
                      _FieldLabel(label: S.of(context).kDescription),
                      SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                      _DescriptionField(
                        controller: _descController,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Description is required'
                            : null,
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
                                height: (isTabletOrUp ? 54.0 : 54.h),
                                child: CustomButton(
                                  onPressed: () {
                                    _submit(context.read<SellerViewModel>());
                                  },
                                  text: 'Save & Continue',
                                  textColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                              ),
                      SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                    ],
                  ),
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

/// ── Supporting widgets ─────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.semiBold16(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.primary),
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
      style: TextStyles.regular14(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDecoration(context, hint),
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
    final theme = Theme.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Row(
      children: [
        Container(
          height: (isTabletOrUp ? 48.0 : 48.h),
          padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 8.0 : 8.w)),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8.rSp(context)),
            color: theme.cardColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              dropdownColor: theme.cardColor,
              icon: Icon(
                Icons.arrow_drop_down,
                size: 18.rSp(context),
                color: theme.hintColor,
              ),
              items: countries.map((c) {
                return DropdownMenuItem<String>(
                  value: c['code'],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c['flag']!, style: TextStyle(fontSize: 18.rSp(context))),
                      SizedBox(width: (isTabletOrUp ? 4.0 : 4.w)),
                      Text(
                        c['code']!,
                        style: TextStyles.regular13(
                          context,
                        ).copyWith(color: theme.colorScheme.onSurface),
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
        SizedBox(width: (isTabletOrUp ? 8.0 : 8.w)),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Phone number is required'
                : null,
            style: TextStyles.regular14(
              context,
            ).copyWith(color: theme.colorScheme.onSurface),
            decoration: _inputDecoration(context, 'Phone Number'),
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
    final theme = Theme.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: (isTabletOrUp ? 52.0 : 52.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: file != null
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8.rSp(context)),
          color: file != null ? theme.colorScheme.secondary : theme.cardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (file != null) ...[
              Icon(
                Icons.check_circle_rounded,
                size: 18.rSp(context),
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: (isTabletOrUp ? 6.0 : 6.w)),
              Text(
                'Image selected',
                style: TextStyles.regular14(
                  context,
                ).copyWith(color: theme.colorScheme.primary),
              ),
            ] else ...[
              Text(
                'Add Image ',
                style: TextStyles.regular14(
                  context,
                ).copyWith(color: theme.hintColor),
              ),
              Icon(Icons.add, size: 18.rSp(context), color: theme.hintColor),
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
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
          style: TextStyles.regular14(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.onSurface),
          decoration: _inputDecoration(context, '').copyWith(
            contentPadding: EdgeInsets.fromLTRB((isTabletOrUp ? 12.0 : 12.w), (isTabletOrUp ? 12.0 : 12.h), (isTabletOrUp ? 12.0 : 12.w), (isTabletOrUp ? 28.0 : 28.h)),
          ),
        ),
        Positioned(
          bottom: (isTabletOrUp ? 8.0 : 8.h),
          right: (isTabletOrUp ? 10.0 : 10.w),
          child: Text(
            '$_charCount/$_maxChars',
            style: TextStyles.regular12(
              context,
            ).copyWith(color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(BuildContext context, String hint) {
  final theme = Theme.of(context);

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyles.regular14(context).copyWith(color: theme.hintColor),
    filled: true,
    fillColor: theme.cardColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    errorMaxLines: 3,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
    ),
  );
}
