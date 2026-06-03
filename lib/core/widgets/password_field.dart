import 'package:flutter/material.dart';
import 'package:safqaseller/core/widgets/custom_text_field.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.hintText,
    this.validator,
    this.enabled = true,
    this.controller,
  });

  final void Function(String?)? onSaved;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextEditingController? controller;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).hintColor;

    return CustomTextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      hintText: widget.hintText,
      textInputType: TextInputType.visiblePassword,
      suffixIcon: InkWell(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: obscureText
            ? Icon(Icons.remove_red_eye, color: iconColor, size: 24.rSp(context))
            : Icon(Icons.visibility_off, color: iconColor, size: 24.rSp(context)),
      ),
    );
  }
}
