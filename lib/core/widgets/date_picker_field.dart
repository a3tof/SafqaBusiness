import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    required this.hintText,
    this.onSaved,
    this.enabled = true,
  });

  final String hintText;
  final void Function(String?)? onSaved;
  final bool enabled;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;
  final TextEditingController controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: theme.colorScheme.onPrimary,
            ),
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('yyyy-MM-dd', 'en').format(picked);
        if (widget.onSaved != null) {
          widget.onSaved!(controller.text);
        }
      });
    }
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
      onTap: widget.enabled ? () => _selectDate(context) : null,
      onSaved: widget.onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.calendar_today,
          color: theme.hintColor,
          size: 20.rSp(context),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyles.bold13(
          context,
        ).copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: buildBorder(theme, context),
        enabledBorder: buildBorder(theme, context),
        focusedBorder: buildBorder(theme, context),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme, BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.rSp(context)),
      borderSide: BorderSide(width: 1, color: theme.colorScheme.outline),
    );
  }
}
