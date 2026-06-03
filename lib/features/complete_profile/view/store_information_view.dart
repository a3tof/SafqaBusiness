import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/legal_documents_view.dart';
import 'package:safqaseller/generated/l10n.dart';

/// Store Information screen – shown for Business Account after Identity Verification.
class StoreInformationView extends StatefulWidget {
  const StoreInformationView({super.key});
  static const String routeName = 'storeInformationView';

  @override
  State<StoreInformationView> createState() => _StoreInformationViewState();
}

class _StoreInformationViewState extends State<StoreInformationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCountry = 'Egypt';
  String _selectedCity = 'Cairo';
  String _selectedPhoneCode = '+20';

  static const List<Map<String, String>> _countries = [
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
  ];

  static const List<String> _cities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Luxor',
    'Aswan',
    'Sharm El Sheikh',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(
        context: context,
        title: S.of(context).kStoreInformation,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w), vertical: (isTabletOrUp ? 12.0 : 12.h)),
            child: ResponsiveFormShell(
              enabled: isTabletOrUp,
              maxWidth: 700,
              child: ResponsiveFormSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(height: (isTabletOrUp ? 8.0 : 8.h)),
                Text(
                  'Verify your business now to build buyer trust and boost your sales',
                  style: TextStyles.regular14(
                    context,
                  ).copyWith(color: Theme.of(context).hintColor, height: 1.5),
                ),
                SizedBox(height: (isTabletOrUp ? 20.0 : 20.h)),

                // Legal Business Name
                _FieldLabel(label: S.of(context).kLegalBusinessName),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                _buildInputField(
                  _nameController,
                  'Store Name',
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                // Business Number
                _FieldLabel(label: S.of(context).kBusinessNumber),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                _PhoneRow(
                  phoneController: _phoneController,
                  countries: _countries,
                  selectedCode: _selectedPhoneCode,
                  onCodeChanged: (c) => setState(() => _selectedPhoneCode = c),
                ),
                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                // Business Address
                _FieldLabel(label: S.of(context).kBusinessAddress),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                ResponsiveFormRow(
                  leading: _DropdownField(
                    value: _selectedCountry,
                    items: _countries.map((c) => c['name']!).toList(),
                    hint: 'Country',
                    onChanged: (v) => setState(
                      () => _selectedCountry = v ?? _selectedCountry,
                    ),
                  ),
                  trailing: _DropdownField(
                    value: _selectedCity,
                    items: _cities,
                    hint: 'City',
                    onChanged: (v) =>
                        setState(() => _selectedCity = v ?? _selectedCity),
                  ),
                ),
                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                // Store Logo (Optional)
                _FieldLabel(label: S.of(context).kStoreLogoOptional),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                _ImagePickerBox(),
                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                // Store Description
                _FieldLabel(label: S.of(context).kStoreDescription),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                _DescriptionField(controller: _descController),
                SizedBox(height: (isTabletOrUp ? 32.0 : 32.h)),

                SizedBox(
                  width: double.infinity,
                  height: isTabletOrUp ? 54.0 : 54.h,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LegalDocumentsView.routeName);
                    },
                    text: 'Save & Continue',
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyles.regular14(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDecoration(context, hint),
    );
  }
}

// ── Shared helper widgets ────────────────────────────────────────────────────

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

class _PhoneRow extends StatelessWidget {
  const _PhoneRow({
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final theme = Theme.of(context);

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

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final theme = Theme.of(context);

    return Container(
      height: (isTabletOrUp ? 48.0 : 48.h),
      padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 12.0 : 12.w)),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8.rSp(context)),
        color: theme.cardColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: theme.cardColor,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 20.rSp(context),
            color: theme.hintColor,
          ),
          style: TextStyles.regular14(
            context,
          ).copyWith(color: theme.colorScheme.onSurface),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  const _ImagePickerBox();

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: (isTabletOrUp ? 52.0 : 52.h),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8.rSp(context)),
          color: theme.cardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Image ',
              style: TextStyles.regular14(
                context,
              ).copyWith(color: theme.hintColor),
            ),
            Icon(Icons.add, size: 18.rSp(context), color: theme.hintColor),
          ],
        ),
      ),
    );
  }
}

class _DescriptionField extends StatefulWidget {
  const _DescriptionField({required this.controller});
  final TextEditingController controller;

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
  int _charCount = 0;
  static const int _maxChars = 50;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(
      () => setState(() => _charCount = widget.controller.text.length),
    );
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
