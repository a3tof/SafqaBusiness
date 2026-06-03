import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';

class ResponsiveFormShell extends StatelessWidget {
  const ResponsiveFormShell({
    super.key,
    required this.enabled,
    required this.maxWidth,
    required this.child,
  });

  final bool enabled;
  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

class ResponsiveFormSection extends StatelessWidget {
  const ResponsiveFormSection({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Container(
      padding: padding ?? EdgeInsets.all(isTabletOrUp ? 24.0 : 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(isTabletOrUp ? 24.0 : 16.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: child,
    );
  }
}

class ResponsiveFormRow extends StatelessWidget {
  const ResponsiveFormRow({
    super.key,
    required this.leading,
    required this.trailing,
    this.spacing,
  });

  final Widget leading;
  final Widget trailing;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: leading),
        SizedBox(width: spacing ?? (isTabletOrUp ? 16.0 : 12.0)),
        Expanded(child: trailing),
      ],
    );
  }
}
