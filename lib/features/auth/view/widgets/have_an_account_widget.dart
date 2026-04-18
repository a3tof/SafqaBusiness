import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class HaveAnAccountWidget extends StatelessWidget {
  const HaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: S.of(context).haveAccount,
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
                Navigator.pushNamed(context, SigninView.routeName);
              },
            text: S.of(context).signIn,
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
