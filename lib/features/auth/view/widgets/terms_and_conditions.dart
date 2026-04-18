import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/view/widgets/custom_check_box.dart';
import 'package:safqaseller/features/terms_and_conditions/view/terms_and_conditions_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isTermsAccepted = false;

  late final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        Navigator.pushNamed(context, TermsAndConditionsView.routeName);

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          onChecked: (value) {
            isTermsAccepted = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isTermsAccepted,
        ),
        SizedBox(width: 16.sp),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${S.of(context).termsAndConditionsPrefix} ',
                  style: TextStyles.semiBold16(
                    context,
                  ).copyWith(color: Theme.of(context).hintColor),
                ),
                TextSpan(
                  text: S.of(context).termsAndConditions,
                  recognizer: _tapRecognizer,
                  style: TextStyles.semiBold16(context).copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
