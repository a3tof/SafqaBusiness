import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/view/edit_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:intl/intl.dart';

class LotDetailView extends StatelessWidget {
  const LotDetailView({super.key, required this.args});

  static const String routeName = 'lotDetailView';

  final LotDetailRouteArgs args;

  static const _items = <_LotDetailItem>[
    _LotDetailItem(name: 'Mercedes C180 2024'),
    _LotDetailItem(name: 'Toyota Corolla 2024'),
    _LotDetailItem(name: 'Kia Cerato 2024'),
  ];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final item = args.item;
    final canEdit = item.status == AuctionStatus.upcoming;

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
                style: TextStyles.semiBold14(context).copyWith(
                  color: AppColors.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 18.sp,
              color: AppColors.primaryColor,
            ),
            if (canEdit) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  EditAuctionView.routeName,
                  arguments: args,
                ),
                child: Text(
                  s.kEdit,
                  style: TextStyles.regular12(context).copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
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
                      item.title,
                      style: TextStyles.semiBold15(context).copyWith(
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: _DateInfo(
                            title: s.auctionStartsIn,
                            value: item.timeLeft ?? '--',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _DateInfo(
                            title: s.auctionEndsIn,
                            value: _formatDate(context, item.endDate),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ...List.generate(
                      _items.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _AuctionItemTile(
                          imageUrl: item.imageUrl,
                          index: index + 1,
                          item: _items[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.auctionTimeLeft,
                              style: TextStyles.regular11(context).copyWith(
                                color: const Color(0xFF9A9A9A),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.timeLeft ?? '--',
                              style: TextStyles.semiBold13(context).copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _priceLabel(context, item.status),
                            style: TextStyles.regular11(context).copyWith(
                              color: const Color(0xFF9A9A9A),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _formatPrice(item.price),
                            style: TextStyles.bold16(context).copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
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
  const _DateInfo({
    required this.title,
    required this.value,
  });

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
            style: TextStyles.regular11(context).copyWith(
              color: const Color(0xFF7D7D7D),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyles.semiBold13(context).copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuctionItemTile extends StatelessWidget {
  const _AuctionItemTile({
    required this.imageUrl,
    required this.index,
    required this.item,
  });

  final String? imageUrl;
  final int index;
  final _LotDetailItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item ($index)',
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _AuctionPreviewImage(
                  imageUrl: imageUrl,
                  width: 70.w,
                  height: 48.h,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyles.semiBold13(context).copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      S.of(context).auctionUsed,
                      style: TextStyles.regular11(context).copyWith(
                        color: const Color(0xFF919191),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: 12.sp,
                          color: const Color(0xFFE26C6C),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '70,000',
                          style: TextStyles.regular11(context).copyWith(
                            color: const Color(0xFF919191),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                S.of(context).auctionDetailsDocs,
                style: TextStyles.regular11(context).copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LotDetailItem {
  const _LotDetailItem({required this.name});

  final String name;
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
