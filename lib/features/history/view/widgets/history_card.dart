import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';
import 'package:safqaseller/generated/l10n.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.item});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(context, item.status);

    return Container(
      constraints: BoxConstraints(minHeight: 130.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFCCCCCC), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: _HistoryImage(imageUrl: item.imageUrl),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatLotNumber(context, item.lotNumber),
                          style: TextStyles.regular14(
                            context,
                          ).copyWith(color: const Color(0xFF888888)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusStyle.backgroundColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          statusStyle.label,
                          style: TextStyles.semiBold11(
                            context,
                          ).copyWith(color: statusStyle.textColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.title,
                    style: TextStyles.medium16(
                      context,
                    ).copyWith(color: AppColors.primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.gavel_rounded,
                        size: 15.sp,
                        color: const Color(0xFF7A7A7A),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item.bidsCount.toString(),
                        style: TextStyles.regular12(
                          context,
                        ).copyWith(color: const Color(0xFF7A7A7A)),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 1,
                        height: 12.h,
                        color: const Color(0xFFD9D9D9),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        _metaIcon(item),
                        size: 15.sp,
                        color: const Color(0xFF7A7A7A),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          _metaValue(context, item),
                          style: TextStyles.regular12(
                            context,
                          ).copyWith(color: const Color(0xFF7A7A7A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _priceLabel(context, item.status),
                    style: TextStyles.regular11(
                      context,
                    ).copyWith(color: const Color(0xFF888888)),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _formatPrice(item.price),
                    style: TextStyles.semiBold14(
                      context,
                    ).copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusStyle _statusStyle(BuildContext context, AuctionStatus status) {
    final s = S.of(context);
    switch (status) {
      case AuctionStatus.upcoming:
        return _StatusStyle(
          label: s.historyStatusUpcoming,
          backgroundColor: Color(0x1A023E8A),
          textColor: Color(0xFF023E8A),
        );
      case AuctionStatus.active:
        return _StatusStyle(
          label: s.historyStatusActive,
          backgroundColor: Color(0x1A00762E),
          textColor: Color(0xFF00762E),
        );
      case AuctionStatus.endingSoon:
        return _StatusStyle(
          label: s.historyStatusEndingSoon,
          backgroundColor: Color(0x1AFF7519),
          textColor: Color(0xFFFF7519),
        );
      case AuctionStatus.finished:
        return _StatusStyle(
          label: s.historyStatusFinished,
          backgroundColor: Color(0x1A808080),
          textColor: Color(0xFF808080),
        );
      case AuctionStatus.canceled:
        return _StatusStyle(
          label: s.historyStatusCanceled,
          backgroundColor: Color(0x1ABA1A1A),
          textColor: Color(0xFFBA1A1A),
        );
      case AuctionStatus.sold:
        return _StatusStyle(
          label: s.historyStatusSold,
          backgroundColor: Color(0x1A00762E),
          textColor: Color(0xFF00762E),
        );
    }
  }

  IconData _metaIcon(HistoryItem item) {
    final usesDate =
        item.endDate != null &&
        (item.status == AuctionStatus.finished ||
            item.status == AuctionStatus.canceled ||
            item.status == AuctionStatus.sold);
    return usesDate ? Icons.calendar_today_outlined : Icons.hourglass_empty;
  }

  String _metaValue(BuildContext context, HistoryItem item) {
    final usesDate =
        item.endDate != null &&
        (item.status == AuctionStatus.finished ||
            item.status == AuctionStatus.canceled ||
            item.status == AuctionStatus.sold);
    if (usesDate) {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMd(locale).format(item.endDate!);
    }
    return item.timeLeft ?? item.mileage ?? '--';
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

  String _formatLotNumber(BuildContext context, String raw) {
    final lotLabel = S.of(context).historyLotLabel;
    if (raw.toLowerCase().startsWith('lot#')) return raw;
    if (raw.startsWith('#')) return '$lotLabel$raw';
    return '$lotLabel#$raw';
  }
}

class _HistoryImage extends StatelessWidget {
  const _HistoryImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final value = imageUrl?.trim();
    if (value == null || value.isEmpty) {
      return _buildPlaceholder();
    }

    if (_looksLikeNetworkUrl(value)) {
      return Image.network(
        value,
        width: 135.w,
        height: 126.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 135.w,
            height: 126.h,
            color: const Color(0xFFF4F4F4),
            alignment: Alignment.center,
            child: SizedBox(
              width: 18.w,
              height: 18.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    final imageBytes = _decodeBase64Image(value);
    if (imageBytes == null) {
      return _buildPlaceholder();
    }

    return Image.memory(
      imageBytes,
      width: 135.w,
      height: 126.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
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

  Widget _buildPlaceholder() {
    return Image.asset(
      Assets.imagesFrame1,
      width: 135.w,
      height: 126.h,
      fit: BoxFit.cover,
    );
  }
}

class _StatusStyle {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusStyle({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}
