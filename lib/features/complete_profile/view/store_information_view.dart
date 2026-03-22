import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/legal_documents_view.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'Store Information'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Verify your business now to build buyer trust and boost your sales',
                  style: TextStyles.regular14(context).copyWith(
                    color: const Color(0xFF444444),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),

                // Legal Business Name
                _FieldLabel(label: 'Legal Business Name'),
                SizedBox(height: 6.h),
                _buildInputField(_nameController, 'Store Name',
                    keyboardType: TextInputType.name),
                SizedBox(height: 16.h),

                // Business Number
                _FieldLabel(label: 'Business Number'),
                SizedBox(height: 6.h),
                _PhoneRow(
                  phoneController: _phoneController,
                  countries: _countries,
                  selectedCode: _selectedPhoneCode,
                  onCodeChanged: (c) =>
                      setState(() => _selectedPhoneCode = c),
                ),
                SizedBox(height: 16.h),

                // Business Address
                _FieldLabel(label: 'Business Address'),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField(
                        value: _selectedCountry,
                        items:
                            _countries.map((c) => c['name']!).toList(),
                        hint: 'Country',
                        onChanged: (v) => setState(
                            () => _selectedCountry = v ?? _selectedCountry),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _DropdownField(
                        value: _selectedCity,
                        items: _cities,
                        hint: 'City',
                        onChanged: (v) => setState(
                            () => _selectedCity = v ?? _selectedCity),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Store Logo (Optional)
                _FieldLabel(label: 'Store Logo (Optional)'),
                SizedBox(height: 6.h),
                _ImagePickerBox(),
                SizedBox(height: 16.h),

                // Store Description
                _FieldLabel(label: 'Store Description'),
                SizedBox(height: 6.h),
                _DescriptionField(controller: _descController),
                SizedBox(height: 32.h),

                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, LegalDocumentsView.routeName);
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
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyles.regular14(context).copyWith(color: Colors.black87),
      decoration: _inputDecoration(hint),
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
      style: TextStyles.semiBold16(context)
          .copyWith(color: AppColors.primaryColor),
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
              icon: Icon(Icons.arrow_drop_down,
                  size: 18.sp, color: Colors.grey),
              items: countries.map((c) {
                return DropdownMenuItem<String>(
                  value: c['code'],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c['flag']!,
                          style: TextStyle(fontSize: 18.sp)),
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
            style:
                TextStyles.regular14(context).copyWith(color: Colors.black87),
            decoration: _inputDecoration('Phone Number'),
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
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE3EE)),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down,
              size: 20.sp, color: Colors.grey),
          style: TextStyles.regular14(context)
              .copyWith(color: Colors.black87),
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
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
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDE3EE)),
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Image ',
              style: TextStyles.regular14(context)
                  .copyWith(color: const Color(0xFF999999)),
            ),
            Icon(Icons.add, size: 18.sp, color: const Color(0xFF999999)),
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
        () => setState(() => _charCount = widget.controller.text.length));
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
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              const SizedBox.shrink(),
          style:
              TextStyles.regular14(context).copyWith(color: Colors.black87),
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
