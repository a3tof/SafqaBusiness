import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

/// Action card used on the seller home screen.
///
/// Renders a background [backgroundImage] asset covered by a translucent blue
/// overlay, a 2 px primary-color border, a drop-shadow, and a centred [label]
/// (optionally with a "+" icon).
class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundImage,
    this.showAddIcon = false,
    this.width,
  });

  final String label;
  final VoidCallback? onTap;
  final String? backgroundImage;
  final bool showAddIcon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlayColor = theme.colorScheme.primary.withValues(alpha: 0.35);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: isTabletOrUp ? 148.0 : 148.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.rSp(context)),
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.rSp(context)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (backgroundImage != null)
                Image.asset(
                  backgroundImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const SizedBox.shrink(),
                ),
              Container(color: overlayColor),
              Center(
                child: Builder(
                  builder: (context) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyles.bold22(context).copyWith(
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      if (showAddIcon) ...[
                        SizedBox(width: isTabletOrUp ? 2.0 : 2.w),
                        Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 40.rSp(context),
                          shadows: const [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black26,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
