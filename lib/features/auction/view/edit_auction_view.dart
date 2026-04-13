import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
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
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final List<_EditableItemData> _items;

  @override
  void initState() {
    super.initState();
    _lotTitleController = TextEditingController(text: widget.args.item.title);
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _items = [_EditableItemData(title: 'Toyota Corolla')];
  }

  @override
  void dispose() {
    _lotTitleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(_EditableItemData(title: widget.args.item.title));
    });
  }

  void _showSavedMessage() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(S.of(context).auctionChangesSaved)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

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
          style: TextStyles.semiBold20(context).copyWith(
            color: AppColors.primaryColor,
          ),
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
                      imageUrl: widget.args.item.imageUrl,
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
              SizedBox(height: 8.h),
              _AuctionTextField(
                controller: _categoryController,
                hintText: s.auctionCategory,
              ),
              SizedBox(height: 16.h),
              ...List.generate(
                _items.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _EditItemCard(
                    index: index + 1,
                    data: _items[index],
                    imageUrl: widget.args.item.imageUrl,
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _addItem,
                  child: Text(
                    '${s.auctionAddItem} +',
                    style: TextStyles.semiBold14(context).copyWith(
                      color: AppColors.primaryColor,
                    ),
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
                  onPressed: _showSavedMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    s.auctionSaveEdits,
                    style: TextStyles.semiBold14(context).copyWith(
                      color: Colors.white,
                    ),
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
  late _AuctionCondition _selectedCondition;

  @override
  void initState() {
    super.initState();
    _selectedCondition = _AuctionCondition.newItem;
  }

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
              Text(
                s.auctionCondition,
                style: TextStyles.regular12(context).copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 6.h,
                children: _AuctionCondition.values.map((condition) {
                  return InkWell(
                    onTap: () => setState(() => _selectedCondition = condition),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedCondition == condition
                                  ? AppColors.primaryColor
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          child: _selectedCondition == condition
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
  _EditableItemData({String title = ''}) : titleController = TextEditingController(text: title);

  final TextEditingController titleController;
  final TextEditingController countController = TextEditingController(text: '1');
  final TextEditingController warrantyController = TextEditingController();

  void dispose() {
    titleController.dispose();
    countController.dispose();
    warrantyController.dispose();
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
