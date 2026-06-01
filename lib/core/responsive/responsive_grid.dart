import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/responsive.dart';

class ResponsiveGridConfig {
  const ResponsiveGridConfig({
    required this.mobile,
    this.tablet,
    this.largeTablet,
    this.desktop,
  });

  final int mobile;
  final int? tablet;
  final int? largeTablet;
  final int? desktop;

  int resolve(BuildContext context) {
    return responsiveValue<int>(
      context,
      mobile: mobile,
      tablet: tablet,
      largeTablet: largeTablet,
      desktop: desktop,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.columns = const ResponsiveGridConfig(
      mobile: 1,
      tablet: 2,
      largeTablet: 3,
      desktop: 4,
    ),
    this.padding = EdgeInsets.zero,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ResponsiveGridConfig columns;
  final EdgeInsetsGeometry padding;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = columns.resolve(context);

    return GridView.builder(
      padding: padding,
      itemCount: itemCount,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: itemBuilder,
    );
  }
}

class ResponsiveSliverGrid extends StatelessWidget {
  const ResponsiveSliverGrid({
    super.key,
    required this.delegate,
    this.columns = const ResponsiveGridConfig(
      mobile: 1,
      tablet: 2,
      largeTablet: 3,
      desktop: 4,
    ),
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio,
    this.mainAxisExtent,
  });

  final SliverChildDelegate delegate;
  final ResponsiveGridConfig columns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = columns.resolve(context);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1,
        mainAxisExtent: mainAxisExtent,
      ),
      delegate: delegate,
    );
  }
}
