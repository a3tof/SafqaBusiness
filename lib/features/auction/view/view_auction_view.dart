// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/view/edit_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view/view_auction_route_args.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model_state.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewAuctionView extends StatefulWidget {
  const ViewAuctionView({super.key, required this.args});

  static const String routeName = 'viewAuctionView';

  final ViewAuctionRouteArgs args;

  @override
  State<ViewAuctionView> createState() => _ViewAuctionViewState();
}

class _ViewAuctionViewState extends State<ViewAuctionView> {
  int _currentImageIndex = 0;
  int _currentItemIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionDetailViewModel>().loadAuction(widget.args.auctionId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(AuctionDetailModel detail) async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.auctionDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              s.auctionDeleteButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final idToDelete = detail.id > 0 ? detail.id : widget.args.auctionId;
      await context.read<AuctionDetailViewModel>().deleteAuction(idToDelete);
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
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<AuctionDetailViewModel, AuctionDetailViewModelState>(
      listener: (context, state) {
        if (state is AuctionDetailDeleteSuccess) {
          _showMessage(s.auctionDeleteSuccess);
          Navigator.pop(context);
        } else if (state is AuctionDetailFailure) {
          _showMessage(state.message.isEmpty ? s.auctionLoadError : state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuctionDetailViewModel>();
        final detail = switch (state) {
          AuctionDetailDeleting(:final detail) => detail,
          AuctionDetailLoaded(:final detail) => detail,
          _ => cubit.detail,
        };

        final isLoading = state is AuctionDetailLoading;
        final isDeleting = state is AuctionDetailDeleting;
        final displayDetail = detail ?? _dummyDetail;

        // Error state with no data
        if (state is AuctionDetailFailure && detail == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(context, null, isDeleting: false, isLoading: false),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: scheme.error),
                    SizedBox(height: 12.h),
                    Text(
                      state.message.isEmpty ? s.auctionLoadError : state.message,
                      style: TextStyles.semiBold16(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => cubit.loadAuction(widget.args.auctionId),
                      child: Text(s.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Gather all images across all items + auction cover
        final allImages = <String>[];
        if (displayDetail.image != null && displayDetail.image!.isNotEmpty) {
          allImages.add(displayDetail.image!);
        }
        for (final item in displayDetail.items) {
          allImages.addAll(item.images);
        }

        final currentItem = displayDetail.items.isNotEmpty
            ? displayDetail.items[_currentItemIndex.clamp(0, displayDetail.items.length - 1)]
            : null;

        // Images for current item view
        final itemImages = <String>[];
        if (displayDetail.image != null && displayDetail.image!.isNotEmpty) {
          itemImages.add(displayDetail.image!);
        }
        if (currentItem != null) {
          itemImages.addAll(currentItem.images);
        }
        final displayImages = itemImages.isNotEmpty ? itemImages : allImages;

        final isMultiItem = displayDetail.items.length > 1;

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(
              context,
              detail,
              isDeleting: isDeleting,
              isLoading: isLoading,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: scheme.primary,
                      onRefresh: () => cubit.loadAuction(widget.args.auctionId),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Image carousel ─────────────────────────────
                            _ImageCarousel(
                              images: displayImages,
                              currentIndex: _currentImageIndex,
                              pageController: _pageController,
                              onPageChanged: (i) =>
                                  setState(() => _currentImageIndex = i),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12.h),

                                  // ── Title + Count ───────────────────────
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentItem?.title.isNotEmpty == true
                                              ? currentItem!.title
                                              : displayDetail.title,
                                          style: TextStyles.bold22(context).copyWith(
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      if (currentItem != null && currentItem.count > 0) ...[
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: scheme.primary.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${s.auctionCount}: ',
                                                  style: TextStyles.regular14(context).copyWith(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${currentItem.count}',
                                                  style: TextStyles.bold18(context).copyWith(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  // ── Attribute chips ─────────────────────
                                  if (currentItem != null &&
                                      currentItem.attributes.isNotEmpty) ...[
                                    _AttributeChipsRow(
                                      attributes: currentItem.attributes,
                                    ),
                                    SizedBox(height: 12.h),
                                  ],

                                  // ── Date range card ─────────────────────
                                  _DateRangeCard(
                                    startDate: displayDetail.startDate,
                                    endDate: displayDetail.endDate,
                                  ),
                                  SizedBox(height: 16.h),

                                  // ── Description ─────────────────────────
                                  if (currentItem != null &&
                                      currentItem.description.trim().isNotEmpty) ...[
                                    _InfoSection(
                                      title: s.auctionLotDescription,
                                      content: currentItem.description,
                                    ),
                                    SizedBox(height: 12.h),
                                  ] else if (displayDetail.description.trim().isNotEmpty) ...[
                                    _InfoSection(
                                      title: s.auctionLotDescription,
                                      content: displayDetail.description,
                                    ),
                                    SizedBox(height: 12.h),
                                  ],

                                  // ── Warranty INFO ───────────────────────
                                  if (currentItem != null &&
                                      currentItem.warrantyInfo.trim().isNotEmpty) ...[
                                    _InfoSection(
                                      title: s.auctionWarrantyInfo,
                                      content: currentItem.warrantyInfo,
                                    ),
                                    SizedBox(height: 12.h),
                                  ],

                                  // ── Condition ───────────────────────────
                                  if (currentItem != null) ...[
                                    _InfoSection(
                                      title: s.auctionCondition,
                                      content: _conditionLabel(context, currentItem.condition),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Previous / Next item buttons ───────────────────────
                  if (isMultiItem)
                    _ItemNavBar(
                      currentIndex: _currentItemIndex,
                      total: displayDetail.items.length,
                      onPrevious: () => setState(() {
                        _currentItemIndex--;
                        _currentImageIndex = 0;
                        _pageController.jumpToPage(0);
                      }),
                      onNext: () => setState(() {
                        _currentItemIndex++;
                        _currentImageIndex = 0;
                        _pageController.jumpToPage(0);
                      }),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AuctionDetailModel? detail, {
    required bool isDeleting,
    required bool isLoading,
  }) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final title = widget.args.auctionTitle ??
        (detail != null ? '#${widget.args.auctionId}' : '#${widget.args.auctionId}');

    // Only show Edit/Delete for auctions with upcoming status (startDate in future)
    final now = DateTime.now();
    final isUpcoming = detail?.startDate != null && detail!.startDate!.isAfter(now);
    final canEdit = isUpcoming && !isLoading;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: scheme.primary,
          size: 20.sp,
        ),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyles.semiBold16(context).copyWith(color: scheme.primary),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        if (canEdit) ...[
          GestureDetector(
            onTap: () async {
              // Build a minimal LotDetailRouteArgs with a dummy HistoryItem
              // carrying the auction id so EditAuctionView can function.
              final fakeItem = HistoryItem(
                id: detail.id > 0 ? detail.id : widget.args.auctionId,
                auctionId: detail.id > 0 ? detail.id : widget.args.auctionId,
                lotNumber: '#${widget.args.auctionId}',
                title: detail.title,
                imageUrl: detail.image,
                price: detail.startingPrice,
                status: AuctionStatus.upcoming,
                bidsCount: 0,
                timeLeft: null,
                endDate: detail.endDate,
                mileage: null,
              );
              final result = await Navigator.pushNamed(
                context,
                EditAuctionView.routeName,
                arguments: LotDetailRouteArgs(item: fakeItem),
              );
              if (result == true && context.mounted) {
                await context.read<AuctionDetailViewModel>().loadAuction(
                  widget.args.auctionId,
                );
              }
            },
            child: Text(
              s.kEdit,
              style: TextStyles.regular14(context).copyWith(
                color: scheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: isDeleting ? null : () => _confirmDelete(detail),
            child: Text(
              s.auctionDeleteButton,
              style: TextStyles.regular14(context).copyWith(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ],
    );
  }

  String _conditionLabel(BuildContext context, int value) {
    final s = S.of(context);
    switch (value) {  // ignore: missing_return
      case 0:
      case 1:
        return s.auctionNew;
      case 2:
        return s.auctionUsedLikeNew;
      default:
        return s.auctionUsed;
    }
  }

  static final _dummyDetail = AuctionDetailModel(
    id: 0,
    title: 'Loading Auction Title...',
    description: 'Loading description for this auction item...',
    image: null,
    startingPrice: 0,
    bidIncrement: 0,
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    items: [
      AuctionDetailItemModel(
        id: 0,
        title: 'Loading Item Title',
        description: 'Loading item description...',
        count: 1,
        condition: 0,
        warrantyInfo: 'Loading warranty info...',
        categoryId: 0,
        attributes: [],
        images: [],
      ),
    ],
  );
}

// ── Image Carousel ────────────────────────────────────────────────────────────

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
  });

  final List<String> images;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final displayImages = images.isNotEmpty ? images : <String>[];
    final total = displayImages.length;

    return Stack(
      children: [
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: total == 0
              ? _AuctionImage(imageSource: null, width: double.infinity, height: 280.h)
              : PageView.builder(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  itemCount: total,
                  itemBuilder: (_, i) => _AuctionImage(
                    imageSource: displayImages[i],
                    width: double.infinity,
                    height: 280.h,
                  ),
                ),
        ),
        if (total > 0)
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, color: Colors.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${currentIndex + 1} / $total',
                      style: TextStyles.regular12(context).copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Attribute chips row ───────────────────────────────────────────────────────

class _AttributeChipsRow extends StatelessWidget {
  const _AttributeChipsRow({required this.attributes});
  final List<ItemAttributeValueModel> attributes;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: attributes
          .where((attr) => attr.value.isNotEmpty)
          .map((attr) => _AttributeChip(value: attr.value))
          .toList(),
    );
  }
}

class _AttributeChip extends StatelessWidget {
  const _AttributeChip({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Text(
        value,
        style: TextStyles.regular14(context).copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ── Date range card ───────────────────────────────────────────────────────────

class _DateRangeCard extends StatelessWidget {
  const _DateRangeCard({required this.startDate, required this.endDate});
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.date_range_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.auctionStartsIn,
                        style: TextStyles.regular12(context)
                            .copyWith(color: const Color(0xFF34BB39)),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _fmt(startDate, locale),
                        style: TextStyles.medium14(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.auctionEndsIn,
                        style: TextStyles.regular12(context)
                            .copyWith(color: Colors.red),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _fmt(endDate, locale),
                        style: TextStyles.medium14(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? date, String locale) {
    if (date == null) return '--';
    return DateFormat('d MMM h:mm a', locale).format(date);
  }
}

// ── Info section (Description / Warranty / Condition) ────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Text(
              title,
              style: TextStyles.semiBold16(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Text(
              content,
              style: TextStyles.regular14(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Item navigation bar ───────────────────────────────────────────────────────

class _ItemNavBar extends StatelessWidget {
  const _ItemNavBar({
    required this.currentIndex,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentIndex;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < total - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: hasPrev ? onPrevious : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.primary,
                side: BorderSide(
                  color: hasPrev ? scheme.primary : const Color(0xFFCCCCCC),
                ),
                backgroundColor: hasPrev
                    ? scheme.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                s.auctionPreviousItem,
                style: TextStyles.semiBold14(context).copyWith(
                  color: hasPrev ? scheme.primary : const Color(0xFFCCCCCC),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: hasNext ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasNext ? scheme.primary : const Color(0xFFCCCCCC),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                s.auctionNextItem,
                style: TextStyles.semiBold14(context).copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image widget (network / base64 / placeholder) ─────────────────────────────

class _AuctionImage extends StatelessWidget {
  const _AuctionImage({
    required this.imageSource,
    required this.width,
    required this.height,
  });

  final String? imageSource;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final src = imageSource?.trim();
    if (src == null || src.isEmpty) return _placeholder();

    final uri = Uri.tryParse(src);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.hasAuthority) {
      return Image.network(
        src,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (ctx, e, stack) => _placeholder(),
      );
    }

    final bytes = _decodeBase64(src);
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (ctx, e, stack) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Uint8List? _decodeBase64(String src) {
    try {
      final clean = src.contains(',') ? src.split(',').last.trim() : src;
      return base64Decode(clean);
    } catch (_) {
      return null;
    }
  }

  Widget _placeholder() => Image.asset(
        Assets.imagesFrame1,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
}
