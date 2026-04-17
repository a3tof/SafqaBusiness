import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view_model/edit_auction/edit_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/edit_auction/edit_auction_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class EditAuctionView extends StatefulWidget {
  const EditAuctionView({super.key, required this.args});

  static const String routeName = 'editAuctionView';

  final LotDetailRouteArgs args;

  @override
  State<EditAuctionView> createState() => _EditAuctionViewState();
}

class _EditAuctionViewState extends State<EditAuctionView> {
  late final TextEditingController _lotTitleController;
  late final TextEditingController _descriptionController;
  final List<_EditableItemData> _items = [];
  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();
    _lotTitleController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditAuctionViewModel>().loadAuction(
        widget.args.item.auctionId,
      );
    });
  }

  @override
  void dispose() {
    _lotTitleController.dispose();
    _descriptionController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _populateForm(AuctionDetailModel detail) {
    _lotTitleController.text = detail.title;
    _descriptionController.text = detail.description;
    for (final item in _items) {
      item.dispose();
    }
    _items
      ..clear()
      ..addAll(detail.items.map(_EditableItemData.fromDetail));
    _didPrefill = true;
    setState(() {});
  }

  Future<void> _saveAuction() async {
    if (_lotTitleController.text.trim().isEmpty) {
      _showMessage(S.of(context).auctionTitle);
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showMessage(S.of(context).kDescription);
      return;
    }

    final items = <EditAuctionItemRequestModel>[];
    for (final item in _items) {
      final count = int.tryParse(item.countController.text.trim());
      final categoryId = int.tryParse(item.categoryIdController.text.trim());
      if (item.titleController.text.trim().isEmpty ||
          item.descriptionController.text.trim().isEmpty ||
          item.warrantyController.text.trim().isEmpty ||
          count == null ||
          count <= 0 ||
          categoryId == null ||
          categoryId <= 0) {
        _showMessage(S.of(context).auctionLoadError);
        return;
      }

      final attributes = item.attributeControllers.entries
          .map(
            (entry) => ItemAttributeValueModel(
              categoryAttributeId: entry.key,
              value: entry.value.text.trim(),
            ),
          )
          .toList();

      items.add(
        EditAuctionItemRequestModel(
          id: item.id,
          title: item.titleController.text.trim(),
          count: count,
          description: item.descriptionController.text.trim(),
          warrantyInfo: item.warrantyController.text.trim(),
          condition: item.selectedCondition.apiValue,
          categoryId: categoryId,
          images: const [],
          attributes: attributes,
        ),
      );
    }

    await context.read<EditAuctionViewModel>().saveAuction(
      id: widget.args.item.auctionId,
      request: EditAuctionRequestModel(
        title: _lotTitleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: null,
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<EditAuctionViewModel, EditAuctionViewModelState>(
      listener: (context, state) {
        if (state is EditAuctionLoaded && !_didPrefill) {
          _populateForm(state.detail);
        } else if (state is EditAuctionSaveSuccess) {
          _showMessage(s.auctionEditSuccess);
          Navigator.pop(context, true);
        } else if (state is EditAuctionFailure) {
          _showMessage(
            state.message.isEmpty ? s.auctionLoadError : state.message,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<EditAuctionViewModel>();
        final detail = switch (state) {
          EditAuctionSaving(:final detail) => detail,
          EditAuctionLoaded(:final detail) => detail,
          _ => cubit.detail,
        };

        if (state is EditAuctionLoading && detail == null) {
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
              child: ElevatedButton(
                onPressed: () => cubit.loadAuction(widget.args.item.auctionId),
                child: Text(s.retry),
              ),
            ),
          );
        }

        final isSaving = state is EditAuctionSaving;

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
            title: Text(
              s.auctionEditTitle,
              style: TextStyles.semiBold20(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: s.auctionLotDetails),
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: 156.w,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE4E4E4)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: _AuctionPreviewImage(
                          imageUrl: detail.image ?? widget.args.item.imageUrl,
                          width: 100.w,
                          height: 76.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _AuctionTextField(
                    controller: _lotTitleController,
                    hintText: s.auctionTitle,
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate(
                    _items.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: _EditItemCard(
                        index: index + 1,
                        data: _items[index],
                        imageUrl: _items[index].previewImages.isNotEmpty
                            ? _items[index].previewImages.first
                            : detail.image ?? widget.args.item.imageUrl,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _SectionLabel(label: s.auctionLotDescription),
                  SizedBox(height: 8.h),
                  _AuctionTextField(
                    controller: _descriptionController,
                    hintText: s.kDescription,
                    minLines: 4,
                    maxLines: 4,
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _saveAuction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        isSaving ? s.kSave : s.auctionSaveEdits,
                        style: TextStyles.semiBold14(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ),
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

class _EditItemCard extends StatefulWidget {
  const _EditItemCard({
    required this.index,
    required this.data,
    required this.imageUrl,
  });

  final int index;
  final _EditableItemData data;
  final String? imageUrl;

  @override
  State<_EditItemCard> createState() => _EditItemCardState();
}

class _EditItemCardState extends State<_EditItemCard> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.auctionItem} (${widget.index})',
          style: TextStyles.semiBold16(context).copyWith(color: Colors.black),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE4E4E4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: _AuctionPreviewImage(
                          imageUrl: widget.imageUrl,
                          width: 76.w,
                          height: 58.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _AuctionTextField(
                controller: widget.data.titleController,
                hintText: s.auctionTitle,
              ),
              SizedBox(height: 8.h),
              _AuctionTextField(
                controller: widget.data.categoryIdController,
                hintText: s.auctionCategory,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              _AuctionTextField(
                controller: widget.data.countController,
                hintText: s.auctionCount,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.h),
              _AuctionTextField(
                controller: widget.data.warrantyController,
                hintText: s.auctionWarrantyInfo,
              ),
              SizedBox(height: 10.h),
              _AuctionTextField(
                controller: widget.data.descriptionController,
                hintText: s.kDescription,
                minLines: 3,
                maxLines: 3,
              ),
              SizedBox(height: 10.h),
              Text(
                s.auctionCondition,
                style: TextStyles.regular12(
                  context,
                ).copyWith(color: Colors.black),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 6.h,
                children: _AuctionCondition.values.map((condition) {
                  return InkWell(
                    onTap: () => setState(
                      () => widget.data.selectedCondition = condition,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.data.selectedCondition == condition
                                  ? AppColors.primaryColor
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          child: widget.data.selectedCondition == condition
                              ? Center(
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          condition.label(context),
                          style: TextStyles.regular12(context),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (widget.data.attributeControllers.isNotEmpty) ...[
                SizedBox(height: 10.h),
                ...widget.data.attributeControllers.entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _AuctionTextField(
                      controller: entry.value,
                      hintText: entry.key.toString(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
      style: TextStyles.semiBold16(context).copyWith(color: Colors.black),
    );
  }
}

class _AuctionTextField extends StatelessWidget {
  const _AuctionTextField({
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyles.regular13(context),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.regular12(
          context,
        ).copyWith(color: const Color(0xFF8A8A8A)),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

class _EditableItemData {
  _EditableItemData({
    required this.id,
    required String title,
    required String count,
    required String categoryId,
    required String warrantyInfo,
    required String description,
    required this.selectedCondition,
    required this.previewImages,
    required this.attributeControllers,
  }) : titleController = TextEditingController(text: title),
       countController = TextEditingController(text: count),
       categoryIdController = TextEditingController(text: categoryId),
       warrantyController = TextEditingController(text: warrantyInfo),
       descriptionController = TextEditingController(text: description);

  factory _EditableItemData.fromDetail(AuctionDetailItemModel item) {
    return _EditableItemData(
      id: item.id,
      title: item.title,
      count: item.count.toString(),
      categoryId: item.categoryId.toString(),
      warrantyInfo: item.warrantyInfo,
      description: item.description,
      selectedCondition: _AuctionCondition.fromApiValue(item.condition),
      previewImages: item.images,
      attributeControllers: {
        for (final attribute in item.attributes)
          attribute.categoryAttributeId: TextEditingController(
            text: attribute.value,
          ),
      },
    );
  }

  final int id;
  final TextEditingController titleController;
  final TextEditingController countController;
  final TextEditingController categoryIdController;
  final TextEditingController warrantyController;
  final TextEditingController descriptionController;
  final List<String> previewImages;
  final Map<int, TextEditingController> attributeControllers;
  _AuctionCondition selectedCondition;

  void dispose() {
    titleController.dispose();
    countController.dispose();
    categoryIdController.dispose();
    warrantyController.dispose();
    descriptionController.dispose();
    for (final controller in attributeControllers.values) {
      controller.dispose();
    }
  }
}

enum _AuctionCondition {
  newItem,
  usedLikeNew,
  used;

  String label(BuildContext context) {
    final s = S.of(context);
    switch (this) {
      case _AuctionCondition.newItem:
        return s.auctionNew;
      case _AuctionCondition.usedLikeNew:
        return s.auctionUsedLikeNew;
      case _AuctionCondition.used:
        return s.auctionUsed;
    }
  }

  static _AuctionCondition fromApiValue(int value) {
    switch (value) {
      case 0:
      case 1:
        return _AuctionCondition.newItem;
      case 2:
        return _AuctionCondition.usedLikeNew;
      default:
        return _AuctionCondition.used;
    }
  }

  int get apiValue {
    switch (this) {
      case _AuctionCondition.newItem:
        return 1;
      case _AuctionCondition.usedLikeNew:
        return 2;
      case _AuctionCondition.used:
        return 3;
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
