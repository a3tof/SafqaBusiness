import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class GenderPickerField extends StatefulWidget {
  const GenderPickerField({
    super.key,
    required this.hintText,
    required this.maleText,
    required this.femaleText,
    this.onSaved,
    this.enabled = true,
  });

  final String hintText;
  final String maleText;
  final String femaleText;
  final void Function(String?)? onSaved;
  final bool enabled;

  @override
  State<GenderPickerField> createState() => _GenderPickerFieldState();
}

class _GenderPickerFieldState extends State<GenderPickerField> {
  String? selectedGender;
  final TextEditingController controller = TextEditingController();

  void _showGenderPicker(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.sp,
                height: 4.sp,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.sp),
              ListTile(
                leading: Icon(
                  Icons.male,
                  color: theme.colorScheme.primary,
                  size: 28.sp,
                ),
                title: Text(
                  widget.maleText,
                  style: TextStyles.semiBold16(context),
                ),
                trailing: selectedGender == widget.maleText
                    ? Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 24.sp,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedGender = widget.maleText;
                    controller.text = widget.maleText;
                    if (widget.onSaved != null) {
                      widget.onSaved!(controller.text);
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(height: 1.sp),
              ListTile(
                leading: Icon(
                  Icons.female,
                  color: theme.colorScheme.primary,
                  size: 28.sp,
                ),
                title: Text(
                  widget.femaleText,
                  style: TextStyles.semiBold16(context),
                ),
                trailing: selectedGender == widget.femaleText
                    ? Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 24.sp,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedGender = widget.femaleText;
                    controller.text = widget.femaleText;
                    if (widget.onSaved != null) {
                      widget.onSaved!(controller.text);
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20.sp),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      readOnly: true,
      onTap: widget.enabled ? () => _showGenderPicker(context) : null,
      onSaved: widget.onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: theme.hintColor,
          size: 24.sp,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyles.bold13(
          context,
        ).copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: buildBorder(theme),
        enabledBorder: buildBorder(theme),
        focusedBorder: buildBorder(theme),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: BorderSide(width: 1, color: theme.colorScheme.outline),
    );
  }
}
