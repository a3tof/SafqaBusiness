import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/seller/view/seller_home_view.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String _selectedBid = '500';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _startingPriceController.dispose();
    _customBidController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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

    final source = _selectedBid == S.of(context).auctionSpecify
        ? _customBidController.text
        : _selectedBid;
    return int.tryParse(normalize(source));
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate?.add(const Duration(days: 1)) ?? now);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: isStart ? now : (_startDate ?? now),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _startDate = selected;
        _startDateController.text = _formatDateTime(selected);
        if (_endDate != null && !_endDate!.isAfter(selected)) {
          _endDate = null;
          _endDateController.clear();
        }
      } else {
        _endDate = selected;
        _endDateController.text = _formatDateTime(selected);
      }
    });
  }

  String _formatDateTime(DateTime value) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('d MMM yyyy, h:mm a', locale).format(value);
  }

  String _durationLabel(S s) {
    if (_startDate == null || _endDate == null) {
      return '--';
    }

    final difference = _endDate!.difference(_startDate!);
    if (difference.inMinutes <= 0) {
      return s.auctionEndDateAfterStart;
    }

    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    return '${days}d : ${hours}h';
  }

  Future<void> _submitAuction() async {
    final s = S.of(context);
    final cubit = _maybeCubit(context);
    if (cubit == null) {
      _showMessage(s.auctionDraftMissing);
      return;
    }

    final startingPrice = double.tryParse(
      _startingPriceController.text.replaceAll(',', '').trim(),
    );
    if (startingPrice == null || startingPrice <= 0) {
      _showMessage(s.auctionValidStartingPriceError);
      return;
    }

    final bidIncrement = _resolveBidIncrement();
    if (bidIncrement == null || bidIncrement <= 0) {
      _showMessage(s.auctionValidBidIncrementError);
      return;
    }

    if (_startDate == null) {
      _showMessage(s.auctionSelectStartDateError);
      return;
    }

    if (_endDate == null) {
      _showMessage(s.auctionSelectEndDateError);
      return;
    }

    if (!_endDate!.isAfter(_startDate!)) {
      _showMessage(s.auctionEndDateAfterStart);
      return;
    }

    await cubit.submitAuction(
      startingPrice: startingPrice,
      bidIncrement: bidIncrement,
      startDate: _startDate!,
      endDate: _endDate!,
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
                route.settings.name == SellerHomeView.routeName ||
                route.isFirst,
          );
        }
      },
      builder: (context, state) {
        final s = S.of(context);
        final isSubmitting = state is CreateAuctionSubmitting;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: buildAppBar(context: context, title: s.auctionPriceDuration),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  _SectionLabel(label: s.historyStartingPrice),
                  SizedBox(height: 6.h),
                  _InputField(
                    controller: _startingPriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _SectionLabel(label: s.auctionBidIncrement),
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
                          label: s.auctionSpecify,
                          selected: _selectedBid == s.auctionSpecify,
                          onTap: () {
                            setState(() => _selectedBid = s.auctionSpecify);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedBid == s.auctionSpecify) ...[
                    SizedBox(height: 8.h),
                    _InputField(
                      controller: _customBidController,
                      hintText: s.auctionBidIncrement,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  SizedBox(height: 18.h),
                  _SectionLabel(label: s.auctionDate),
                  SizedBox(height: 6.h),
                  _DateField(
                    controller: _startDateController,
                    hintText: s.auctionStartDate,
                    onTap: () => _pickDateTime(isStart: true),
                  ),
                  SizedBox(height: 8.h),
                  _DateField(
                    controller: _endDateController,
                    hintText: s.auctionEndDate,
                    onTap: () => _pickDateTime(isStart: false),
                  ),
                  SizedBox(height: 18.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          s.auctionDuration,
                          style: TextStyles.regular12(
                            context,
                          ).copyWith(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _durationLabel(s),
                          style: TextStyles.semiBold14(
                            context,
                          ).copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  child: _PrimaryButton(
                    label: isSubmitting
                        ? s.auctionPublishing
                        : s.auctionBoostPublish,
                    onTap: isSubmitting ? null : _submitAuction,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.hintText,
    required this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: TextStyles.semiBold14(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.regular12(
          context,
        ).copyWith(color: Theme.of(context).hintColor),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 20.sp,
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
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
      style: TextStyles.regular12(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
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
      ).copyWith(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
          color: selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.regular11(context).copyWith(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyles.semiBold14(context).copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
