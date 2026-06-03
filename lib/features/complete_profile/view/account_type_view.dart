import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/complete_profile/view/seller_information_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class AccountTypeView extends StatefulWidget {
  const AccountTypeView({super.key});
  static const String routeName = 'accountTypeView';

  @override
  State<AccountTypeView> createState() => _AccountTypeViewState();
}

class _AccountTypeViewState extends State<AccountTypeView> {
  _AccountType? _selected;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context: context, title: S.of(context).kAccountType),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w)),
          child: ResponsiveFormShell(
            enabled: isTabletOrUp,
            maxWidth: 700,
            child: ResponsiveFormSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: (isTabletOrUp ? 32.0 : 32.h)),
                  _AccountTypeCard(
                    type: _AccountType.personal,
                    selected: _selected == _AccountType.personal,
                    onTap: () => setState(() => _selected = _AccountType.personal),
                  ),
                  SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                  _AccountTypeCard(
                    type: _AccountType.business,
                    selected: _selected == _AccountType.business,
                    onTap: () => setState(() => _selected = _AccountType.business),
                  ),
                  SizedBox(height: (isTabletOrUp ? 32.0 : 32.h)),
                  CustomButton(
                    onPressed: () {
                      if (_selected == null) return;
                      if (_selected == _AccountType.personal) {
                        Navigator.pushNamed(
                          context,
                          SellerInformationView.routeName,
                          arguments: _AccountType.personal,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          SellerInformationView.routeName,
                          arguments: _AccountType.business,
                        );
                      }
                    },
                    text: 'Continue',
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: _selected != null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _AccountType { personal, business }

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final _AccountType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final isPersonal = type == _AccountType.personal;
    final title = isPersonal ? 'Personal Account' : 'Business Account';
    final description = isPersonal
        ? 'Designed for individuals selling personal belongings and used items. (Requires National ID only)'
        : 'Designed for registered companies and verified stores. (Requires submitting official documents: Commercial Register & Tax ID)';
    final icon = isPersonal
        ? Icons.person_outline_rounded
        : Icons.business_outlined;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w), vertical: (isTabletOrUp ? 16.0 : 16.h)),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.secondary : theme.cardColor,
          borderRadius: BorderRadius.circular(12.rSp(context)),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 32.rSp(context)),
            SizedBox(width: (isTabletOrUp ? 12.0 : 12.w)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.semiBold16(
                      context,
                    ).copyWith(color: theme.colorScheme.primary),
                  ),
                  SizedBox(height: (isTabletOrUp ? 4.0 : 4.h)),
                  Text(
                    description,
                    style: TextStyles.regular14(
                      context,
                    ).copyWith(color: theme.hintColor, height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
