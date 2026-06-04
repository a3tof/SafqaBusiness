import 'package:flutter/material.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/generated/l10n.dart';

class TermsAndConditionsViewBody extends StatelessWidget {
  const TermsAndConditionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTabletOrUp ? 24.0 : kHorizontalPadding.rSp(context),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: isTabletOrUp ? 24.0 : 24.rSp(context),
          ),
          child: ResponsiveFormShell(
            enabled: isTabletOrUp,
            maxWidth: 700,
            child: ResponsiveFormSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildParagraph(context, s.termsPlatformCompliance, isTabletOrUp),
                  _buildParagraph(context, s.termsAccurateInfo, isTabletOrUp),
                  _buildParagraph(context, s.termsSuspendAccounts, isTabletOrUp),
                  _buildParagraph(context, s.termsMonitored, isTabletOrUp),
                  _buildSectionHeader(context, s.termsBuyerAppTitle, isTabletOrUp),
                  _buildSectionHeader(context, s.termsAccountUsageTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsBuyerAge, isTabletOrUp),
                  _buildParagraph(context, s.termsBuyerCredentials, isTabletOrUp),
                  _buildParagraph(context, s.termsBuyerMultipleAccounts, isTabletOrUp),
                  _buildSectionHeader(context, s.termsBiddingRulesTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsBindingBids, isTabletOrUp),
                  _buildParagraph(context, s.termsHighestBidWins, isTabletOrUp),
                  _buildParagraph(context, s.termsProxyBiddingRules, isTabletOrUp),
                  _buildParagraph(context, s.termsManipulateBids, isTabletOrUp),
                  _buildSectionHeader(context, s.termsPaymentsTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsWalletBalance, isTabletOrUp),
                  _buildParagraph(context, s.termsSecurityDeposits, isTabletOrUp),
                  _buildParagraph(context, s.termsRefundsPolicy, isTabletOrUp),
                  _buildSectionHeader(context, s.termsDisputesTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsRaiseDisputes, isTabletOrUp),
                  _buildParagraph(context, s.termsDisputeDecisions, isTabletOrUp),
                  _buildSectionHeader(context, s.termsSellerAppTitle, isTabletOrUp),
                  _buildSectionHeader(context, s.termsSellerRegTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsSellerVerification, isTabletOrUp),
                  _buildParagraph(context, s.termsSellerApproval, isTabletOrUp),
                  _buildParagraph(context, s.termsSellerAccuracy, isTabletOrUp),
                  _buildSectionHeader(context, s.termsAuctionMgmtTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsHonestDescriptions, isTabletOrUp),
                  _buildParagraph(context, s.termsAuctionRules, isTabletOrUp),
                  _buildParagraph(context, s.termsNoModifyActive, isTabletOrUp),
                  _buildSectionHeader(context, s.termsDeliveryTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsTimelyDelivery, isTabletOrUp),
                  _buildParagraph(context, s.termsDeliveryInfo, isTabletOrUp),
                  _buildParagraph(context, s.termsFailureToDeliver, isTabletOrUp),
                  _buildSectionHeader(context, s.termsFeesTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsPlatformFees, isTabletOrUp),
                  _buildParagraph(context, s.termsTrackEarnings, isTabletOrUp),
                  _buildSectionHeader(context, s.termsNotifPolicyTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsNotifGenerated, isTabletOrUp),
                  _buildParagraph(context, s.termsNotifInformational, isTabletOrUp),
                  _buildParagraph(context, s.termsReviewNotif, isTabletOrUp),
                  _buildSectionHeader(context, s.termsPrivacyDataTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsDataCollected, isTabletOrUp),
                  _buildParagraph(context, s.termsDataProtected, isTabletOrUp),
                  _buildParagraph(context, s.termsNoShareData, isTabletOrUp),
                  _buildSectionHeader(context, s.termsLiabilityTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsNotResponsible, isTabletOrUp),
                  _buildParagraph(context, s.termsDowntime, isTabletOrUp),
                  _buildParagraph(context, s.termsIntermediary, isTabletOrUp),
                  _buildSectionHeader(context, s.termsChangesTitle, isTabletOrUp),
                  _buildParagraph(context, s.termsUpdatedAnytime, isTabletOrUp),
                  _buildParagraph(context, s.termsContinuedUse, isTabletOrUp),
                  SizedBox(height: isTabletOrUp ? 16.0 : 16.rSp(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text, bool isTabletOrUp) {
    return Padding(
      padding: EdgeInsets.only(
        top: isTabletOrUp ? 8.0 : 8.rSp(context),
        bottom: isTabletOrUp ? 4.0 : 4.rSp(context),
      ),
      child: Text(
        text,
        style: TextStyles.regular16(context).copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text, bool isTabletOrUp) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTabletOrUp ? 6.0 : 6.rSp(context),
      ),
      child: Text(
        text,
        style: TextStyles.regular16(context).copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          height: 1.5,
        ),
      ),
    );
  }
}
