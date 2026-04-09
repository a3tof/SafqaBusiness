import 'package:flutter/material.dart';
import 'package:safqaseller/generated/l10n.dart';

class SubscriptionPlanModel {
  const SubscriptionPlanModel({
    required this.name,
    required this.price,
    required this.features,
    required this.ctaLabel,
    required this.upgradeType,
  });

  final String name;
  final String price;
  final List<String> features;
  final String ctaLabel;
  final int upgradeType;

  static List<SubscriptionPlanModel> plans(BuildContext context) => [
    SubscriptionPlanModel(
      name: S.of(context).kBasic,
      price: '99\$',
      features: [
        S.of(context).kAppearsAtTheTop24,
        S.of(context).kFeaturedBadge,
        S.of(context).kHighlightedCard,
      ],
      ctaLabel: S.of(context).kBoostNow,
      upgradeType: 1,
    ),
    SubscriptionPlanModel(
      name: S.of(context).kPremium,
      price: '499\$',
      features: [
        S.of(context).kAppearsAtTheTop3D,
        S.of(context).kPushNotifications,
        S.of(context).kFeaturedBadgeHighl,
        S.of(context).kBasicAnalytics,
      ],
      ctaLabel: S.of(context).kUpgradeToPremium,
      upgradeType: 2,
    ),
    SubscriptionPlanModel(
      name: S.of(context).kElite,
      price: '999\$',
      features: [
        S.of(context).kPinnedAsTopBanner,
        S.of(context).kInstantPushNotific,
        S.of(context).kFeaturedBadge,
        S.of(context).kDetailedAnalytics,
      ],
      ctaLabel: S.of(context).kGoElite,
      upgradeType: 3,
    ),
  ];
}
