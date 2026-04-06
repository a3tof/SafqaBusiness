import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class WithdrawalViewBody extends StatefulWidget {
  const WithdrawalViewBody({super.key});

  @override
  State<WithdrawalViewBody> createState() => _WithdrawalViewBodyState();
}

class _WithdrawalViewBodyState extends State<WithdrawalViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;
    context.read<WithdrawalViewModel>().withdraw(amount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WithdrawalViewModel, WithdrawalState>(
      listener: (context, state) {
        if (state is WithdrawalSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).kWithdrawalSuccessfu),
              backgroundColor: Color(0xFF7DD97B),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is WithdrawalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context: context, title: S.of(context).kWithdrawal),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).kEnterWithdrawalAmo,
                          style: TextStyles.medium20(context)),
                      SizedBox(height: 24.h),
                      Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _amountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter an amount';
                            }
                            final n = double.tryParse(v.trim());
                            if (n == null || n <= 0) {
                              return 'Enter a valid amount';
                            }
                            return null;
                          },
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            hintText: '0.00',
                            hintStyle: TextStyle(
                                fontSize: 20.sp, color: Colors.grey[400]),
                            prefixText: '\$ ',
                            prefixStyle: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
                child: BlocBuilder<WithdrawalViewModel, WithdrawalState>(
                  builder: (context, state) {
                    final isLoading = state is WithdrawalLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Withdraw',
                                style: TextStyles.semiBold19(context)
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
