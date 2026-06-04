import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';

class AddCardViewBody extends StatefulWidget {
  const AddCardViewBody({super.key});

  @override
  State<AddCardViewBody> createState() => _AddCardViewBodyState();
}

class _AddCardViewBodyState extends State<AddCardViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _holderCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();

  static final List<TextInputFormatter> _cardNumberFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    _CardNumberInputFormatter(),
  ];

  static final List<TextInputFormatter> _expiryDateFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    _ExpiryDateInputFormatter(),
  ];

  static final List<TextInputFormatter> _cvvFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(3),
  ];

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final sanitizedCardNumber = _cardNumberCtrl.text.replaceAll(' ', '');
    final sanitizedExpiry = _expiryCtrl.text.trim();
    final sanitizedCvv = _cvvCtrl.text.trim();

    context.read<AddCardViewModel>().addCard(
      AddCardRequest(
        cardNumber: sanitizedCardNumber,
        expiryDate: sanitizedExpiry,
        cvv: sanitizedCvv,
        cardholderName: _holderCtrl.text.trim(),
        label: _labelCtrl.text.trim().isEmpty ? null : _labelCtrl.text.trim(),
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    final digits = value?.replaceAll(' ', '') ?? '';
    if (digits.isEmpty) return S.of(context).fieldRequired;
    if (digits.length != 16) return 'Card number must be 16 digits';
    return null;
  }

  String? _validateExpiryDate(String? value) {
    final expiry = value?.trim() ?? '';
    if (expiry.isEmpty) return S.of(context).fieldRequired;
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
      return 'Expiry date must be in MM/YY format';
    }

    final month = int.tryParse(expiry.substring(0, 2));
    if (month == null || month < 1 || month > 12) {
      return 'Enter a valid month';
    }

    return null;
  }

  String? _validateCvv(String? value) {
    final cvv = value?.trim() ?? '';
    if (cvv.isEmpty) return S.of(context).fieldRequired;
    if (cvv.length != 3) return 'CVV must be 3 digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BlocListener<AddCardViewModel, AddCardState>(
      listener: (context, state) {
        if (state is AddCardSuccess) {
          Navigator.pop(context, true);
        } else if (state is AddCardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<AddCardViewModel, AddCardState>(
        builder: (context, state) {
          final isLoading = state is AddCardLoading;
          return Skeletonizer(
            enabled: isLoading,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 28.rSp(context),
                  ),
                ),
                title: Text(
                  S.of(context).kAddCard,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Localizations.localeOf(context).languageCode == 'ar' ? 'Cairo' : 'AlegreyaSC',
                    fontSize: 28.rSp(context),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: (isTabletOrUp ? 16.0 : 16.w),
                          vertical: (isTabletOrUp ? 16.0 : 16.h),
                        ),
                        child: ResponsiveFormShell(
                          enabled: isTabletOrUp,
                          maxWidth: 700,
                          child: ResponsiveFormSection(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter your card information',
                                  style: TextStyles.medium20(context).copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                                _CardField(
                                  controller: _cardNumberCtrl,
                                  hint: 'Card Number',
                                  keyboardType: TextInputType.number,
                                  maxLength: 19,
                                  inputFormatters: _cardNumberFormatters,
                                  validator: _validateCardNumber,
                                ),
                                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _CardField(
                                        controller: _expiryCtrl,
                                        hint: 'Expiry Date',
                                        keyboardType: TextInputType.datetime,
                                        maxLength: 5,
                                        inputFormatters: _expiryDateFormatters,
                                        validator: _validateExpiryDate,
                                      ),
                                    ),
                                    SizedBox(width: (isTabletOrUp ? 9.0 : 9.w)),
                                    Expanded(
                                      child: _CardField(
                                        controller: _cvvCtrl,
                                        hint: 'CVV',
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        inputFormatters: _cvvFormatters,
                                        obscureText: true,
                                        validator: _validateCvv,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                                _CardField(
                                  controller: _holderCtrl,
                                  hint: 'Cardholder Name',
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? S.of(context).fieldRequired
                                      : null,
                                ),
                                SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                                _CardField(
                                  controller: _labelCtrl,
                                  hint: 'Card Label (Optional)',
                                ),
                                SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                                SizedBox(
                                  width: double.infinity,
                                  height: (isTabletOrUp ? 54.0 : 54.h),
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.rSp(context),
                                        ),
                                      ),
                                    ),
                                    child: isLoading
                                        ? SizedBox(
                                            width: (isTabletOrUp ? 20.0 : 20.w),
                                            height: (isTabletOrUp
                                                ? 20.0
                                                : 20.w),
                                            child: CircularProgressIndicator(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            S.of(context).kAddCard,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyles.semiBold16(
                                                  context,
                                                ).copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                                ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Styled input field matching the card form while staying theme-aware.
class _CardField extends StatelessWidget {
  const _CardField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      style: TextStyles.regular14(
        context,
      ).copyWith(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        counterText: '',
        hintText: hint,
        hintStyle: TextStyles.semiBold13(
          context,
        ).copyWith(
          color: theme.brightness == Brightness.dark ? Colors.white54 : theme.hintColor,
        ),
        filled: true,
        fillColor: theme.brightness == Brightness.dark ? theme.colorScheme.surface : theme.cardColor,
        errorMaxLines: 3,
        constraints: BoxConstraints(minHeight: (isTabletOrUp ? 48.0 : 48.h)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: (isTabletOrUp ? 16.0 : 16.w),
          vertical: (isTabletOrUp ? 14.0 : 14.h),
        ),
        border: _buildBorder(theme, context),
        enabledBorder: _buildBorder(theme, context),
        focusedBorder: _buildBorder(
          theme,
          context,
          color: theme.colorScheme.primary,
        ),
        errorBorder: _buildBorder(
          theme,
          context,
          color: theme.colorScheme.error,
        ),
        focusedErrorBorder: _buildBorder(
          theme,
          context,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(
    ThemeData theme,
    BuildContext context, {
    Color? color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.rSp(context)),
      borderSide: BorderSide(
        color: color ?? theme.colorScheme.outline,
        width: 0.5,
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final truncated = digitsOnly.length > 16
        ? digitsOnly.substring(0, 16)
        : digitsOnly;
    final formatted = _formatCardNumber(truncated);
    final selectionIndex = _calculateCardNumberSelection(
      formatted,
      truncated.length,
      newValue.selection.extentOffset,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  static String _formatCardNumber(String value) {
    final buffer = StringBuffer();
    for (var index = 0; index < value.length; index++) {
      if (index > 0 && index % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(value[index]);
    }
    return buffer.toString();
  }

  static int _calculateCardNumberSelection(
    String formatted,
    int digitsLength,
    int rawSelection,
  ) {
    final digitsSeen = rawSelection.clamp(0, digitsLength);
    var cursorPosition = 0;
    var digitsPlaced = 0;
    while (cursorPosition < formatted.length && digitsPlaced < digitsSeen) {
      if (formatted[cursorPosition] != ' ') {
        digitsPlaced++;
      }
      cursorPosition++;
    }

    return cursorPosition.clamp(0, formatted.length);
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final truncated = digitsOnly.length > 4
        ? digitsOnly.substring(0, 4)
        : digitsOnly;
    final formatted = _formatExpiryDate(truncated);
    final selectionIndex = _calculateSelection(
      formatted,
      truncated.length,
      newValue.selection.extentOffset,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  static String _formatExpiryDate(String value) {
    if (value.length <= 2) {
      return value.length == 2 ? '$value/' : value;
    }

    return '${value.substring(0, 2)}/${value.substring(2)}';
  }

  static int _calculateSelection(
    String formatted,
    int digitsLength,
    int rawSelection,
  ) {
    final digitsSeen = rawSelection.clamp(0, digitsLength);
    var cursorPosition = 0;
    var digitsPlaced = 0;
    while (cursorPosition < formatted.length && digitsPlaced < digitsSeen) {
      if (formatted[cursorPosition] != '/') {
        digitsPlaced++;
      }
      cursorPosition++;
    }

    return cursorPosition.clamp(0, formatted.length);
  }
}
