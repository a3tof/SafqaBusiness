import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
import 'package:safqaseller/features/auction/view/edit_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model_state.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';
import 'package:safqaseller/generated/l10n.dart';

class LotDetailView extends StatefulWidget {
  const LotDetailView({super.key, required this.args});

  static const String routeName = 'lotDetailView';

  final LotDetailRouteArgs args;

  @override
  State<LotDetailView> createState() => _LotDetailViewState();
}

class _LotDetailViewState extends State<LotDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionDetailViewModel>().loadAuction(
        widget.args.item.auctionId,
      );
    });
  }

  Future<void> _confirmDelete() async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final localizations = MaterialLocalizations.of(dialogContext);
        return AlertDialog(
          content: Text(s.auctionDeleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(s.auctionDeleteButton),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await context.read<AuctionDetailViewModel>().deleteAuction(
        widget.args.item.auctionId,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final item = widget.args.item;
    final canEdit = item.status == AuctionStatus.upcoming;

    return BlocConsumer<AuctionDetailViewModel, AuctionDetailViewModelState>(
      listener: (context, state) {
        if (state is AuctionDetailDeleteSuccess) {
          _showMessage(s.auctionDeleteSuccess);
          Navigator.pop(context);
        } else if (state is AuctionDetailFailure) {
          _showMessage(
            state.message.isEmpty ? s.auctionLoadError : state.message,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuctionDetailViewModel>();
        final detail = switch (state) {
          AuctionDetailDeleting(:final detail) => detail,
          AuctionDetailLoaded(:final detail) => detail,
          _ => cubit.detail,
        };

        if (state is AuctionDetailLoading && detail == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (detail == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.auctionLoadError,
                      style: TextStyles.semiBold16(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () =>
                          cubit.loadAuction(widget.args.item.auctionId),
                      child: Text(s.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final isDeleting = state is AuctionDetailDeleting;
        final displayPrice = detail.startingPrice > 0
            ? detail.startingPrice
            : item.price;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatLotNumber(context, item.lotNumber),
                    style: TextStyles.semiBold14(
                      context,
                    ).copyWith(color: AppColors.primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canEdit) ...[
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      EditAuctionView.routeName,
                      arguments: widget.args,
                    ),
                    child: Text(
                      s.kEdit,
                      style: TextStyles.regular12(
                        context,
                      ).copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: isDeleting ? null : _confirmDelete,
                    child: Text(
                      s.auctionDeleteButton,
                      style: TextStyles.regular12(
                        context,
                      ).copyWith(color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.title,
                          style: TextStyles.semiBold15(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: _DateInfo(
                                title: s.auctionStartsIn,
                                value: _formatDate(context, detail.startDate),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _DateInfo(
                                title: s.auctionEndsIn,
                                value: _formatDate(context, detail.endDate),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          s.auctionLotDescription,
                          style: TextStyles.semiBold16(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          detail.description,
                          style: TextStyles.regular12(
                            context,
                          ).copyWith(color: const Color(0xFF666666)),
                        ),
                        SizedBox(height: 12.h),
                        ...List.generate(
                          detail.items.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _AuctionItemTile(
                              index: index + 1,
                              item: detail.items[index],
                              auctionImage: detail.image ?? item.imageUrl,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.auctionTimeLeft,
                              style: TextStyles.regular11(
                                context,
                              ).copyWith(color: const Color(0xFF9A9A9A)),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.timeLeft ?? '--',
                              style: TextStyles.semiBold13(
                                context,
                              ).copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _priceLabel(context, item.status),
                            style: TextStyles.regular11(
                              context,
                            ).copyWith(color: const Color(0xFF9A9A9A)),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _formatPrice(displayPrice),
                            style: TextStyles.bold16(
                              context,
                            ).copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatLotNumber(BuildContext context, String raw) {
    final lotLabel = S.of(context).historyLotLabel;
    if (raw.toLowerCase().startsWith('lot#')) return raw;
    if (raw.startsWith('#')) return '$lotLabel$raw';
    return '$lotLabel#$raw';
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return '--';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('d MMM h:mm a', locale).format(date);
  }

  String _priceLabel(BuildContext context, AuctionStatus status) {
    final s = S.of(context);
    switch (status) {
      case AuctionStatus.upcoming:
      case AuctionStatus.canceled:
        return s.historyStartingPrice;
      case AuctionStatus.active:
      case AuctionStatus.endingSoon:
        return s.historyCurrentPrice;
      case AuctionStatus.finished:
      case AuctionStatus.sold:
        return s.historyFinalPrice;
    }
  }

  String _formatPrice(double value) {
    return '\$${NumberFormat('#,##0.##').format(value)}';
  }
}

class _DateInfo extends StatelessWidget {
  const _DateInfo({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE0E6EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.regular11(
              context,
            ).copyWith(color: const Color(0xFF7D7D7D)),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyles.semiBold13(
              context,
            ).copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}

class _AuctionItemTile extends StatelessWidget {
  const _AuctionItemTile({
    required this.index,
    required this.item,
    required this.auctionImage,
  });

  final int index;
  final AuctionDetailItemModel item;
  final String? auctionImage;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.images.isNotEmpty ? item.images.first : auctionImage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${S.of(context).auctionItem} ($index)',
          style: TextStyles.regular12(context).copyWith(color: Colors.black),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE6E6E6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _AuctionPreviewImage(
                  imageUrl: imageUrl,
                  width: 70.w,
                  height: 64.h,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyles.semiBold13(
                        context,
                      ).copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _conditionLabel(context, item.condition),
                      style: TextStyles.regular11(
                        context,
                      ).copyWith(color: const Color(0xFF919191)),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${S.of(context).auctionCount}: ${item.count}',
                      style: TextStyles.regular11(
                        context,
                      ).copyWith(color: const Color(0xFF919191)),
                    ),
                    if (item.warrantyInfo.trim().isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        item.warrantyInfo,
                        style: TextStyles.regular11(
                          context,
                        ).copyWith(color: const Color(0xFF919191)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.description.trim().isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        item.description,
                        style: TextStyles.regular11(
                          context,
                        ).copyWith(color: const Color(0xFF666666)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _conditionLabel(BuildContext context, int value) {
    final s = S.of(context);
    switch (value) {
      case 0:
      case 1:
        return s.auctionNew;
      case 2:
        return s.auctionUsedLikeNew;
      default:
        return s.auctionUsed;
    }
  }
}

class _AuctionPreviewImage extends StatelessWidget {
  const _AuctionPreviewImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final value = imageUrl?.trim();
    if (value == null || value.isEmpty) {
      return _placeholder();
    }

    if (_looksLikeNetworkUrl(value)) {
      return Image.network(
        value,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    final imageBytes = _decodeBase64Image(value);
    if (imageBytes == null) {
      return _placeholder();
    }

    return Image.memory(
      imageBytes,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  bool _looksLikeNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.hasAuthority;
  }

  Uint8List? _decodeBase64Image(String value) {
    try {
      final normalizedValue = value.contains(',')
          ? value.split(',').last.trim()
          : value;
      return base64Decode(normalizedValue);
    } catch (_) {
      return null;
    }
  }

  Widget _placeholder() {
    return Image.asset(
      Assets.imagesFrame1,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
