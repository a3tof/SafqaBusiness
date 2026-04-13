import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/seller/view/seller_home_view.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model_state.dart';

class PriceDurationView extends StatefulWidget {
  const PriceDurationView({super.key});

  static const String routeName = 'priceDurationView';

  @override
  State<PriceDurationView> createState() => _PriceDurationViewState();
}

class _PriceDurationViewState extends State<PriceDurationView> {
  final TextEditingController _startingPriceController =
      TextEditingController();
  final TextEditingController _customBidController = TextEditingController();
  final TextEditingController _customDurationController =
      TextEditingController();
  String _selectedBid = '500';
  String _selectedDuration = '7 days';

  @override
  void dispose() {
    _startingPriceController.dispose();
    _customBidController.dispose();
    _customDurationController.dispose();
    super.dispose();
  }

  CreateAuctionViewModel? _maybeCubit(BuildContext context) {
    try {
      return context.read<CreateAuctionViewModel>();
    } catch (_) {
      return null;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  int? _resolveBidIncrement() {
    String normalize(String value) => value.replaceAll(',', '').trim();

    final source = _selectedBid == 'Specify'
        ? _customBidController.text
        : _selectedBid;
    return int.tryParse(normalize(source));
  }

  int? _resolveDuration() {
    if (_selectedDuration == 'Specify') {
      return int.tryParse(_customDurationController.text.trim());
    }
    return int.tryParse(_selectedDuration.split(' ').first);
  }

  String _auctionEndLabel() {
    final days = _resolveDuration();
    if (days == null || days <= 0) {
      return 'Select a valid duration';
    }
    final endDate = DateTime.now().add(Duration(days: days));
    return DateFormat('EEE, MMM d, yyyy h:mm a').format(endDate);
  }

  Future<void> _submitAuction() async {
    final cubit = _maybeCubit(context);
    if (cubit == null) {
      _showMessage('Auction draft is missing.');
      return;
    }

    final startingPrice = double.tryParse(
      _startingPriceController.text.replaceAll(',', '').trim(),
    );
    if (startingPrice == null || startingPrice <= 0) {
      _showMessage('Please enter a valid starting price.');
      return;
    }

    final bidIncrement = _resolveBidIncrement();
    if (bidIncrement == null || bidIncrement <= 0) {
      _showMessage('Please enter a valid bid increment.');
      return;
    }

    final durationInDays = _resolveDuration();
    if (durationInDays == null || durationInDays <= 0) {
      _showMessage('Please enter a valid duration.');
      return;
    }

    await cubit.submitAuction(
      startingPrice: startingPrice,
      bidIncrement: bidIncrement,
      durationInDays: durationInDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAuctionViewModel, CreateAuctionViewModelState>(
      listener: (context, state) {
        if (state is CreateAuctionFailure) {
          _showMessage(state.message);
        } else if (state is CreateAuctionSubmitSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HistoryView.routeName,
            (route) =>
                route.settings.name == SellerHomeView.routeName || route.isFirst,
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is CreateAuctionSubmitting;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context: context, title: 'Price & Duration'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'Starting Price'),
                  SizedBox(height: 6.h),
                  _InputField(
                    controller: _startingPriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const _SectionLabel(label: 'Bid Increment'),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '100',
                          selected: _selectedBid == '100',
                          onTap: () {
                            setState(() => _selectedBid = '100');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '300',
                          selected: _selectedBid == '300',
                          onTap: () {
                            setState(() => _selectedBid = '300');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '500',
                          selected: _selectedBid == '500',
                          onTap: () {
                            setState(() => _selectedBid = '500');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _ChoiceChipBox(
                          label: 'Specify',
                          selected: _selectedBid == 'Specify',
                          onTap: () {
                            setState(() => _selectedBid = 'Specify');
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedBid == 'Specify') ...[
                    SizedBox(height: 8.h),
                    _InputField(
                      controller: _customBidController,
                      hintText: 'Enter bid increment',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  SizedBox(height: 18.h),
                  const _SectionLabel(label: 'Auction Duration'),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '1 day',
                          selected: _selectedDuration == '1 day',
                          onTap: () {
                            setState(() => _selectedDuration = '1 day');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '3 days',
                          selected: _selectedDuration == '3 days',
                          onTap: () {
                            setState(() => _selectedDuration = '3 days');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceChipBox(
                          label: '7 days',
                          selected: _selectedDuration == '7 days',
                          onTap: () {
                            setState(() => _selectedDuration = '7 days');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _ChoiceChipBox(
                          label: 'Specify',
                          selected: _selectedDuration == 'Specify',
                          onTap: () {
                            setState(() => _selectedDuration = 'Specify');
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedDuration == 'Specify') ...[
                    SizedBox(height: 8.h),
                    _InputField(
                      controller: _customDurationController,
                      hintText: 'Enter number of days',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  SizedBox(height: 18.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Your auction ends on',
                          style: TextStyles.regular12(
                            context,
                          ).copyWith(color: const Color(0xFF666666)),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _auctionEndLabel(),
                          style: TextStyles.semiBold14(
                            context,
                          ).copyWith(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _PrimaryButton(
                    label: isSubmitting ? 'Publishing...' : 'Boost & Publish',
                    onTap: isSubmitting ? null : _submitAuction,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.regular12(context).copyWith(color: Colors.black),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({this.controller, this.hintText, this.keyboardType});

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyles.semiBold14(
        context,
      ).copyWith(color: AppColors.primaryColor),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

class _ChoiceChipBox extends StatelessWidget {
  const _ChoiceChipBox({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: selected ? AppColors.primaryColor : const Color(0xFFE4E4E4),
          ),
        ),
        child: Text(
          label,
          style: TextStyles.regular11(context).copyWith(
            color: selected ? AppColors.primaryColor : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyles.semiBold14(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
