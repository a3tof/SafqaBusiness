import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model_state.dart';

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
    context.read<AddCardViewModel>().addCard(
          AddCardRequest(
            cardNumber: _cardNumberCtrl.text.trim(),
            expiryDate: _expiryCtrl.text.trim(),
            cvv: _cvvCtrl.text.trim(),
            cardholderName: _holderCtrl.text.trim(),
            label: _labelCtrl.text.trim().isEmpty ? null : _labelCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddCardViewModel, AddCardState>(
      listener: (context, state) {
        if (state is AddCardSuccess) {
          Navigator.pop(context, true);
        } else if (state is AddCardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: Colors.red, size: 28.sp),
          ),
          title: Text(
            'Add Card',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your card information',
                        style: TextStyles.medium20(context),
                      ),
                      SizedBox(height: 16.h),
                      // Card Number
                      _CardField(
                        controller: _cardNumberCtrl,
                        hint: 'Card Number',
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),
                      // Expiry + CVV row
                      Row(
                        children: [
                          Expanded(
                            child: _CardField(
                              controller: _expiryCtrl,
                              hint: 'Expiry Date',
                              keyboardType: TextInputType.datetime,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 9.w),
                          Expanded(
                            child: _CardField(
                              controller: _cvvCtrl,
                              hint: 'CVV',
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Cardholder Name
                      _CardField(
                        controller: _holderCtrl,
                        hint: 'Cardholder Name',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),
                      // Label (optional)
                      _CardField(
                        controller: _labelCtrl,
                        hint: 'Card Label (Optional)',
                      ),
                    ],
                  ),
                ),
              ),
              // Add button pinned at bottom
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
                child: BlocBuilder<AddCardViewModel, AddCardState>(
                  builder: (context, state) {
                    final isLoading = state is AddCardLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Add',
                                style: TextStyles.semiBold16(context)
                                    .copyWith(color: Colors.white),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Styled input field matching the Figma card form field.
/// Design: white bg, #CCC 0.5px border, shadow, 48px height, 4px radius.
class _CardField extends StatelessWidget {
  const _CardField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLength,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFCCCCCC), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF808080),
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
