import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/utils/currency_formatter.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
import 'package:safqaseller/features/auction/view/edit_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model.dart';
import 'package:safqaseller/features/auction/view_model/auction_detail/auction_detail_view_model_state.dart';
import 'package:safqaseller/features/auction/view/view_auction_route_args.dart';
import 'package:safqaseller/features/auction/view/view_auction_view.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _dummyDetail = AuctionDetailModel(
  id: 0,
  title: 'Loading Auction Title...',
  description: 'Loading description...',
  image: null,
  startingPrice: 0,
  bidIncrement: 0,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(const Duration(days: 1)),
  categoryId: 0,
  items: [
    AuctionDetailItemModel(
      id: 0,
      title: 'Loading Item Title...',
      description: 'Loading item description...',
      count: 1,
      condition: 0,
      warrantyInfo: 'Loading warranty...',
      categoryId: 0,
      attributes: [],
      images: [],
    ),
  ],
);

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
  return CurrencyFormatter.format(value);
}

List<TextSpan> _parseTitle(String title, BuildContext context) {
  final idx = title.indexOf('(');
  if (idx != -1) {
    return [
      TextSpan(text: '${title.substring(0, idx).trimRight()} '),
      TextSpan(
        text: title.substring(idx),
        style: TextStyles.regular14(
          context,
        ).copyWith(color: Theme.of(context).hintColor),
      ),
    ];
  }
  return [TextSpan(text: title)];
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
      final cubit = context.read<AuctionDetailViewModel>();
      final detailId = cubit.detail?.id ?? 0;
      final idToDelete = detailId > 0 ? detailId : widget.args.item.auctionId;
      await cubit.deleteAuction(idToDelete);
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
    final isSplitLayout = Breakpoints.isLargeTabletOrUp(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return BlocConsumer<AuctionDetailViewModel, AuctionDetailViewModelState>(
      listener: (context, state) {
        if (state is AuctionDetailDeleteSuccess) {
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

        final isLoading = state is AuctionDetailLoading;
        final displayDetail = detail ?? _dummyDetail;

        if (!isLoading && detail == null) {
          return Scaffold(
            backgroundColor: isSplitLayout
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: isSplitLayout
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                  size: isTabletOrUp ? 20.0 : 20.rSp(context),
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTabletOrUp ? 24.0 : 24.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.auctionLoadError,
                      style: TextStyles.semiBold16(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
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

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            backgroundColor: isSplitLayout
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: isSplitLayout
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                  size: isTabletOrUp ? 20.0 : 20.rSp(context),
                ),
              ),
              centerTitle: true,
              title: Text(
                '#${displayDetail.id > 0 ? displayDetail.id : item.auctionId}',
                style: TextStyles.semiBold20(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                if (canEdit) ...[
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        EditAuctionView.routeName,
                        arguments: widget.args,
                      );
                      if (result == true && context.mounted) {
                        await context
                            .read<AuctionDetailViewModel>()
                            .loadAuction(widget.args.item.auctionId);
                      }
                    },
                    child: Text(
                      s.kEdit,
                      style: TextStyles.semiBold14(context).copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(width: isTabletOrUp ? 16.0 : 16.w),
                  GestureDetector(
                    onTap: isDeleting ? null : _confirmDelete,
                    child: Text(
                      s.auctionDeleteButton,
                      style: TextStyles.semiBold14(context).copyWith(
                        color: const Color(0xFFD80505),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(width: isTabletOrUp ? 16.0 : 16.w),
                ],
              ],
            ),
            body: isSplitLayout
                ? LotDetailSplitLayout(
                    displayDetail: displayDetail,
                    item: item,
                    args: widget.args,
                  )
                : LotDetailMobileLayout(
                    displayDetail: displayDetail,
                    item: item,
                    args: widget.args,
                  ),
          ),
        );
      },
    );
  }
}

class LotDetailSplitLayout extends StatelessWidget {
  const LotDetailSplitLayout({
    super.key,
    required this.displayDetail,
    required this.item,
    required this.args,
  });

  final AuctionDetailModel displayDetail;
  final HistoryItem item;
  final LotDetailRouteArgs args;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: LotDetailContent(
                    displayDetail: displayDetail,
                    item: item,
                    args: args,
                    isSplitLayout: true,
                  ),
                ),
                const SizedBox(width: 24.0),
                SizedBox(
                  width: 400.0,
                  child: LotDetailSidePanel(
                    displayDetail: displayDetail,
                    item: item,
                    isSplitLayout: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LotDetailMobileLayout extends StatelessWidget {
  const LotDetailMobileLayout({
    super.key,
    required this.displayDetail,
    required this.item,
    required this.args,
  });

  final AuctionDetailModel displayDetail;
  final HistoryItem item;
  final LotDetailRouteArgs args;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveFormShell(
        enabled: false,
        maxWidth: 700,
        child: Stack(
          children: [
            Positioned.fill(
              child: LotDetailContent(
                displayDetail: displayDetail,
                item: item,
                args: args,
                isSplitLayout: false,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LotDetailSidePanel(
                displayDetail: displayDetail,
                item: item,
                isSplitLayout: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LotDetailContent extends StatelessWidget {
  const LotDetailContent({
    super.key,
    required this.displayDetail,
    required this.item,
    required this.args,
    required this.isSplitLayout,
  });

  final AuctionDetailModel displayDetail;
  final HistoryItem item;
  final LotDetailRouteArgs args;
  final bool isSplitLayout;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return RefreshIndicator(
      onRefresh: () =>
          context.read<AuctionDetailViewModel>().loadAuction(item.auctionId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: isSplitLayout
            ? const EdgeInsets.all(24.0)
            : EdgeInsets.fromLTRB(
                isTabletOrUp ? 16.0 : 16.w,
                isTabletOrUp ? 8.0 : 8.h,
                isTabletOrUp ? 16.0 : 16.w,
                120.0,
              ),
        child: Container(
          decoration: isSplitLayout
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                )
              : null,
          padding: isSplitLayout ? const EdgeInsets.all(24.0) : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyles.bold18(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.onSurface),
                  children: _parseTitle(displayDetail.title, context),
                ),
              ),
              SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
              Text(
                displayDetail.description,
                style: TextStyles.regular14(
                  context,
                ).copyWith(color: Theme.of(context).hintColor),
              ),
              SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isTabletOrUp ? 10.0 : 10.h,
                  horizontal: isTabletOrUp ? 16.0 : 16.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    isTabletOrUp ? 6.0 : 6.rSp(context),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: isTabletOrUp ? 24.0 : 24.rSp(context),
                    ),
                    SizedBox(width: isTabletOrUp ? 16.0 : 16.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                s.auctionStartsIn,
                                style: TextStyles.regular12(
                                  context,
                                ).copyWith(color: const Color(0xFF34BB39)),
                              ),
                              SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
                              Text(
                                _formatDate(context, displayDetail.startDate),
                                style: TextStyles.semiBold13(context).copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                s.auctionEndsIn,
                                style: TextStyles.regular12(
                                  context,
                                ).copyWith(color: const Color(0xFFD80505)),
                              ),
                              SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
                              Text(
                                _formatDate(context, displayDetail.endDate),
                                style: TextStyles.semiBold13(context).copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
              ...List.generate(
                displayDetail.items.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: isTabletOrUp ? 12.0 : 12.h),
                  child: _AuctionItemTile(
                    index: index + 1,
                    item: displayDetail.items[index],
                    auctionImage: displayDetail.image ?? item.imageUrl,
                    auctionId: item.auctionId,
                    auctionTitle: displayDetail.title,
                    rootCategoryId: displayDetail.categoryId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LotDetailSidePanel extends StatelessWidget {
  const LotDetailSidePanel({
    super.key,
    required this.displayDetail,
    required this.item,
    required this.isSplitLayout,
  });

  final AuctionDetailModel displayDetail;
  final HistoryItem item;
  final bool isSplitLayout;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final displayPrice = displayDetail.startingPrice > 0
        ? displayDetail.startingPrice
        : item.price;

    return Container(
      padding: isSplitLayout
          ? const EdgeInsets.all(24.0)
          : EdgeInsets.fromLTRB(
              isTabletOrUp ? 16.0 : 16.w,
              isTabletOrUp ? 10.0 : 10.h,
              isTabletOrUp ? 16.0 : 16.w,
              isTabletOrUp ? 16.0 : 16.h,
            ),
      decoration: BoxDecoration(
        color: isSplitLayout
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).cardColor,
        borderRadius: isSplitLayout
            ? BorderRadius.circular(20.0)
            : BorderRadius.vertical(
                top: Radius.circular(isTabletOrUp ? 20.0 : 20.rSp(context)),
              ),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            const BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
        ],
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.auctionTimeLeft,
                    textAlign: TextAlign.start,
                    style: TextStyles.regular11(
                      context,
                    ).copyWith(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: isTabletOrUp ? 2.0 : 2.h),
                  _LiveCountdown(
                    endDate: displayDetail.endDate ?? item.endDate,
                    fallbackTimeLeft: item.timeLeft,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _priceLabel(context, item.status),
                    textAlign: TextAlign.end,
                    style: TextStyles.regular11(
                      context,
                    ).copyWith(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: isTabletOrUp ? 2.0 : 2.h),
                  Text(
                    _formatPrice(displayPrice),
                    textAlign: TextAlign.end,
                    style: TextStyles.bold16(
                      context,
                    ).copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuctionItemTile extends StatelessWidget {
  const _AuctionItemTile({
    required this.index,
    required this.item,
    required this.auctionImage,
    required this.auctionId,
    required this.auctionTitle,
    required this.rootCategoryId,
  });

  final int index;
  final AuctionDetailItemModel item;
  final String? auctionImage;
  final int auctionId;
  final String auctionTitle;
  final int rootCategoryId;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final imageUrl = item.images.isNotEmpty ? item.images.first : auctionImage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${S.of(context).auctionItem} $index',
          style: TextStyles.semiBold14(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        SizedBox(height: isTabletOrUp ? 6.0 : 6.h),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            ViewAuctionView.routeName,
            arguments: ViewAuctionRouteArgs(
              auctionId: auctionId,
              auctionTitle: auctionTitle,
              initialItemIndex: index > 0 ? index - 1 : 0,
            ),
          ),
          child: Container(
            height: isTabletOrUp ? 110.0 : 96.h,
            padding: const EdgeInsets.all(2),
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(
                  isTabletOrUp ? 8.0 : 8.rSp(context),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: isTabletOrUp ? 100.0 : 96.w,
                  height: double.infinity,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isTabletOrUp ? 6.0 : 6.rSp(context),
                      ),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _AuctionPreviewImage(
                    imageUrl: imageUrl,
                    width: isTabletOrUp ? 100.0 : 96.w,
                    height: isTabletOrUp ? 100.0 : 92.h,
                  ),
                ),
                SizedBox(width: isTabletOrUp ? 16.0 : 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: TextStyles.medium16(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTabletOrUp ? 6.0 : 8.h),
                      Text(
                        _conditionLabel(context, item.condition),
                        style: TextStyles.regular14(context).copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(
                                    item.categoryId > 0
                                        ? item.categoryId
                                        : rootCategoryId,
                                  ),
                                  size: isTabletOrUp ? 24.0 : 20.rSp(context),
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    _getCategoryName(
                                      context,
                                      item.categoryId > 0
                                          ? item.categoryId
                                          : rootCategoryId,
                                    ),
                                    style: TextStyles.regular14(context)
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTabletOrUp ? 8.0 : 6.w,
                              vertical: isTabletOrUp ? 6.0 : 4.h,
                            ),
                            decoration: ShapeDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  isTabletOrUp ? 4.0 : 4.rSp(context),
                                ),
                              ),
                            ),
                            child: Text(
                              S.of(context).auctionDetailsDocs,
                              style: TextStyles.regular12(context).copyWith(
                                fontSize: isTabletOrUp ? 12.0 : 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTabletOrUp ? 16.0 : 10.w),
              ],
            ),
          ),
        ),
      ],
    );
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
    Breakpoints.isTabletOrUp(context);
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
    return Center(
      child: Icon(
        Icons.gavel_rounded,
        size: width * 0.4,
        color: const Color(0xFF3A7BD5),
      ),
    );
  }
}

class _LiveCountdown extends StatefulWidget {
  const _LiveCountdown({
    required this.endDate,
    this.fallbackTimeLeft,
    this.textAlign,
  });

  final DateTime? endDate;
  final String? fallbackTimeLeft;
  final TextAlign? textAlign;
  @override
  State<_LiveCountdown> createState() => _LiveCountdownState();
}

class _LiveCountdownState extends State<_LiveCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayTime = '--';
    if (widget.endDate != null) {
      final diff = widget.endDate!.difference(DateTime.now());
      if (diff.isNegative) {
        displayTime = '0m : 0s';
      } else {
        final days = diff.inDays;
        final hours = diff.inHours.remainder(24);
        final minutes = diff.inMinutes.remainder(60);
        final seconds = diff.inSeconds.remainder(60);
        if (days > 0) {
          displayTime = '${days}d : ${hours}h : ${minutes}m : ${seconds}s';
        } else if (hours > 0) {
          displayTime = '${hours}h : ${minutes}m : ${seconds}s';
        } else {
          displayTime = '${minutes}m : ${seconds}s';
        }
      }
    } else {
      displayTime = widget.fallbackTimeLeft ?? '--';
    }

    return Text(
      displayTime,
      textAlign: widget.textAlign,
      style: TextStyles.semiBold13(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

String _getCategoryName(BuildContext context, int categoryId) {
  final s = S.of(context);
  switch (categoryId) {
    case 1:
      return s.categoryElectronics;
    case 2:
      return s.categoryVehicles;
    case 3:
      return s.categoryRealEstate;
    case 4:
      return s.categorySports;
    case 5:
      return s.categoryBooksAndMedia;
    case 6:
      return s.categoryToysAndHobbies;
    default:
      return 'Unknown Category';
  }
}

IconData _getCategoryIcon(int categoryId) {
  switch (categoryId) {
    case 1:
      return Icons.devices_outlined;
    case 2:
      return Icons.directions_car_outlined;
    case 3:
      return Icons.real_estate_agent_outlined;
    case 4:
      return Icons.sports_soccer_outlined;
    case 5:
      return Icons.menu_book_outlined;
    case 6:
      return Icons.toys_outlined;
    default:
      return Icons.category_outlined;
  }
}
