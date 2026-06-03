import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  final bool isChecked;
  final ValueChanged<bool> onChecked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChecked(!isChecked);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 24.rSp(context),
        width: 24.rSp(context),
        decoration: ShapeDecoration(
          color: isChecked ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.50,
              color: isChecked ? Colors.transparent : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(8.rSp(context)),
          ),
        ),
        child: isChecked
            ? Padding(
                padding: EdgeInsets.all(2.rSp(context)),
                child: SvgPicture.asset(Assets.imagesCheck),
              )
            : SizedBox(),
      ),
    );
  }
}
