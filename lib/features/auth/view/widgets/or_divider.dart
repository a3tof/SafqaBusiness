import 'package:flutter/material.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/generated/l10n.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: const Color(0xFFDCDEDE), thickness: 1)),
        SizedBox(width: 18.rSp(context)),
        Text(S.of(context).or, style: TextStyles.semiBold16(context)),
        SizedBox(width: 18.rSp(context)),
        Expanded(child: Divider(color: const Color(0xFFDCDEDE), thickness: 1)),
      ],
    );
  }
}
