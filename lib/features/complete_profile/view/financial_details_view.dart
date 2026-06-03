import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/custom_button.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/complete_profile/view/legal_documents_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/seller/view/seller_home_view.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

/// Financial Details screen – final step of Business Account profile completion.
/// Combines financial form fields with legal document files from previous step
/// to call POST /api/seller/{sellerId}/business-verification.
class FinancialDetailsView extends StatefulWidget {
  const FinancialDetailsView({super.key, this.legalDocs});
  static const String routeName = 'financialDetailsView';

  final LegalDocumentsArgs? legalDocs;

  @override
  State<FinancialDetailsView> createState() => _FinancialDetailsViewState();
}

class _FinancialDetailsViewState extends State<FinancialDetailsView> {
  final _formKey = GlobalKey<FormState>();
  final _iPayController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _localAccountController = TextEditingController();

  String? _selectedBank;

  static const List<String> _banks = [
    'National Bank of Egypt',
    'Banque Misr',
    'CIB',
    'QNB',
    'HSBC Egypt',
    'Arab African International Bank',
    'Banque du Caire',
    'Abu Dhabi Islamic Bank',
  ];

  @override
  void dispose() {
    _iPayController.dispose();
    _accountNameController.dispose();
    _ibanController.dispose();
    _localAccountController.dispose();
    super.dispose();
  }

  Future<void> _submit(SellerViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).kPleaseSelectABank),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    final docs = widget.legalDocs;
    if (docs == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).kLegalDocumentsAre),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    final commercialRegister = await MultipartFile.fromFile(
      docs.commercialRegister.path,
      filename: 'commercial_register.jpg',
    );
    final taxId = await MultipartFile.fromFile(
      docs.taxId.path,
      filename: 'tax_id.jpg',
    );
    final ownerNationalIdFront = await MultipartFile.fromFile(
      docs.ownerNationalIdFront.path,
      filename: 'owner_id_front.jpg',
    );
    final ownerNationalIdBack = await MultipartFile.fromFile(
      docs.ownerNationalIdBack.path,
      filename: 'owner_id_back.jpg',
    );

    int? instaPayNum;
    if (_iPayController.text.trim().isNotEmpty) {
      instaPayNum = int.tryParse(_iPayController.text.trim());
    }

    await viewModel.uploadBusinessVerification(
      commercialRegister: commercialRegister,
      taxId: taxId,
      ownerNationalIdFront: ownerNationalIdFront,
      ownerNationalIdBack: ownerNationalIdBack,
      bankName: _selectedBank!,
      accountName: _accountNameController.text.trim(),
      iban: _ibanController.text.trim(),
      localAccountNumber: _localAccountController.text.trim().isEmpty
          ? null
          : _localAccountController.text.trim(),
      instaPayNumber: instaPayNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BlocProvider(
      create: (_) => getIt<SellerViewModel>(),
      child: BlocConsumer<SellerViewModel, SellerViewModelState>(
        listener: (context, state) {
          if (state is BusinessVerificationSuccess) {
            // All steps complete: update role to Seller
            getIt<AuthViewModel>().setRole('Seller');
            getIt<ProfileViewModel>().completeProfile();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Your business profile has been submitted for review!'),
                backgroundColor: Color(0xFF023E8A),
              ),
            );

            // Navigate to SellerHomeView and clear the stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              SellerHomeView.routeName,
              (route) => false,
            );
          } else if (state is SellerError) {
            final msg = state.message == 'SERVER_ERROR_HTML' 
                ? S.of(context).serverError 
                : state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SellerLoading;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar:
                buildAppBar(context: context, title: S.of(context).kFinancialDetails),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB((isTabletOrUp ? 16.0 : 16.w), (isTabletOrUp ? 20.0 : 20.h), (isTabletOrUp ? 16.0 : 16.w), (isTabletOrUp ? 16.0 : 16.h)),
                  child: ResponsiveFormShell(
                    enabled: isTabletOrUp,
                    maxWidth: 700,
                    child: ResponsiveFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveFormRow(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Insta Pay Number
                                _FieldLabel(label: S.of(context).kInstaPayNumberOp),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _InputField(
                                  controller: _iPayController,
                                  hint: 'IP Number',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bank Name
                                _FieldLabel(label: S.of(context).kBankName),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _BankDropdown(
                                  value: _selectedBank,
                                  banks: _banks,
                                  onChanged: (v) =>
                                      setState(() => _selectedBank = v),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                          ResponsiveFormRow(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Account Name / Beneficiary Name
                                _FieldLabel(
                                    label: S.of(context).kAccountNameBenef),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _InputField(
                                  controller: _accountNameController,
                                  hint: 'Account Name',
                                  keyboardType: TextInputType.name,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'Account name is required'
                                          : null,
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Company IBAN
                                _FieldLabel(label: S.of(context).kCompanyIban),
                                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                                _InputField(
                                  controller: _ibanController,
                                  hint: 'IBAN',
                                  keyboardType: TextInputType.text,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                          ? 'IBAN is required'
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),

                          // Local Account Number (Optional)
                          _FieldLabel(
                              label: S.of(context).kLocalAccountNumber),
                          SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                          _InputField(
                            controller: _localAccountController,
                            hint: 'Local Account Number',
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: (isTabletOrUp ? 20.0 : 20.h)),

                          // Note
                      Container(
                        padding: EdgeInsets.all((isTabletOrUp ? 12.0 : 12.w)),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8.rSp(context)),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Note: ',
                                style: TextStyles.semiBold13(context)
                                    .copyWith(
                                        color: Theme.of(context).colorScheme.primary),
                              ),
                              TextSpan(
                                text:
                                    '"Bank account name must strictly match the legal business name provided in the Commercial Register."',
                                style:
                                    TextStyles.regular13(context).copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: (isTabletOrUp ? 32.0 : 32.h)),

                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: (isTabletOrUp ? 54.0 : 54.h),
                              child: CustomButton(
                                onPressed: () {
                                  _submit(
                                      context.read<SellerViewModel>());
                                },
                                text: 'Submit for Review',
                                textColor: Colors.white,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                      SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.semiBold16(context)
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyles.regular14(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
      decoration: _inputDecoration(context, hint),
    );
  }
}

class _BankDropdown extends StatelessWidget {
  const _BankDropdown({
    required this.value,
    required this.banks,
    required this.onChanged,
  });

  final String? value;
  final List<String> banks;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Container(
      height: (isTabletOrUp ? 48.0 : 48.h),
      padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 12.0 : 12.w)),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8.rSp(context)),
        color: Theme.of(context).cardColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            'Bank Name',
            style: TextStyles.regular14(context)
                .copyWith(color: Theme.of(context).hintColor),
          ),
          icon:
              Icon(Icons.arrow_drop_down, size: 20.rSp(context), color: Theme.of(context).hintColor),
          style:
              TextStyles.regular14(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
          dropdownColor: Theme.of(context).cardColor,
          items: banks
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(BuildContext context, String hint) {
  final theme = Theme.of(context);
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyles.regular14(context).copyWith(color: theme.hintColor),
    filled: true,
    fillColor: theme.cardColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
    ),
  );
}
