import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/view/signup_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class DontHaveAnAccountWidet extends StatelessWidget {
  const DontHaveAnAccountWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: S.of(context).dontHaveAccount,
            style: TextStyles.semiBold16(
              context,
            ).copyWith(color: Theme.of(context).hintColor),
          ),
          TextSpan(
            text: ' ',
            style: TextStyles.semiBold16(
              context,
            ).copyWith(color: Theme.of(context).hintColor),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigate to signup view
                Navigator.pushNamed(context, SignupView.routeName);
              },
            text: S.of(context).createAccount,
            style: TextStyles.semiBold16(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
