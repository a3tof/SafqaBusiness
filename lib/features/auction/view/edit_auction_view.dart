import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/utils/app_images.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view_model/edit_auction/edit_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/edit_auction/edit_auction_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditAuctionView extends StatefulWidget {
  const EditAuctionView({super.key, required this.args});

  static const String routeName = 'editAuctionView';

  final LotDetailRouteArgs args;

  @override
  State<EditAuctionView> createState() => _EditAuctionViewState();
}

class _EditAuctionViewState extends State<EditAuctionView> {
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _lotTitleController;
  late final TextEditingController _descriptionController;
  final List<_EditableItemData> _items = [];
  int? _lotCategoryId;
  XFile? _headImage;
  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();
    _lotTitleController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
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

  Future<void> _loadInitialData() async {
    final cubit = context.read<EditAuctionViewModel>();
    try {
      await cubit.loadCategories();
    } catch (e) {
      if (mounted) {
        _showMessage(_cleanError(e));
      }
    }

    if (!mounted) {
      return;
    }

    await cubit.loadAuction(widget.args.item.auctionId);
  }

  Future<void> _pickHeadImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) {
      return;
    }
    setState(() => _headImage = image);
  }

  Future<void> _pickItemImages(int itemIndex) async {
    final images = await _imagePicker.pickMultiImage();
    if (!mounted || images.isEmpty || itemIndex >= _items.length) {
      return;
    }
    setState(() {
      _items[itemIndex].pickedImages.addAll(images);
    });
  }

  void _populateForm(AuctionDetailModel detail) {
    _lotTitleController.text = detail.title;
    _descriptionController.text = detail.description;
    _lotCategoryId = detail.categoryId > 0
        ? detail.categoryId
        : (detail.items.isNotEmpty ? detail.items.first.categoryId : null);
    if (_lotCategoryId == 0) _lotCategoryId = null;

    for (final item in _items) {
      item.dispose();
    }
    _items
      ..clear()
      ..addAll(detail.items.map(_EditableItemData.fromDetail));
    _didPrefill = true;
    setState(() {});
    for (var index = 0; index < _items.length; index++) {
      final categoryId = _lotCategoryId ?? _items[index].categoryId;
      if (categoryId > 0) {
        _loadAttributesForItem(
          itemIndex: index,
          categoryId: categoryId,
          preserveExistingValues: true,
        );
      }
    }
  }

  Future<void> _loadAttributesForItem({
    required int itemIndex,
    required int categoryId,
    bool preserveExistingValues = false,
  }) async {
    final cubit = context.read<EditAuctionViewModel>();
    try {
      await cubit.loadAttributes(itemIndex: itemIndex, categoryId: categoryId);
      if (!mounted || itemIndex >= _items.length) {
        return;
      }
      setState(() {
        _items[itemIndex].syncAttributes(
          cubit.attributesForItem(itemIndex),
          preserveExistingValues: preserveExistingValues,
        );
      });
    } catch (_) {
      if (!mounted || itemIndex >= _items.length) {
        return;
      }
      setState(() {
        _items[itemIndex].syncAttributes(
          const [],
          preserveExistingValues: preserveExistingValues,
        );
      });
      final error =
          cubit.attributeErrorForItem(itemIndex) ??
          'Could not load category attributes.';
      _showMessage(error);
    }
  }

  void _onLotCategoryChanged(int? newCategoryId) {
    if (newCategoryId == null) return;
    setState(() => _lotCategoryId = newCategoryId);
    for (var i = 0; i < _items.length; i++) {
      _items[i].categoryId = newCategoryId;
      _items[i].syncAttributes(const []);
      _loadAttributesForItem(itemIndex: i, categoryId: newCategoryId);
    }
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
    final s = S.of(context);
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final itemNumber = i + 1;
      final count = int.tryParse(item.countController.text.trim());
      if (item.titleController.text.trim().isEmpty ||
          item.descriptionController.text.trim().isEmpty ||
          item.warrantyController.text.trim().isEmpty) {
        _showMessage(s.auctionItemFieldsRequired(itemNumber));
        return;
      }
      if (count == null || count <= 0) {
        _showMessage(s.auctionItemInvalidCount(itemNumber));
        return;
      }
      if (item.categoryId <= 0) {
        _showMessage('Please select a category for item $itemNumber.');
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
          categoryId: item.categoryId,
          images: item.pickedImages,
          attributes: attributes,
        ),
      );
    }

    await context.read<EditAuctionViewModel>().saveAuction(
      id: widget.args.item.auctionId,
      request: EditAuctionRequestModel(
        title: _lotTitleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _headImage,
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);
    final cubit = context.read<EditAuctionViewModel>();
    final categories = cubit.categories;
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
        final detail = switch (state) {
          EditAuctionSaving(:final detail) => detail,
          EditAuctionLoaded(:final detail) => detail,
          _ => cubit.detail,
        };

        final isLoading = state is EditAuctionLoading;
        final displayDetail = detail ?? _dummyDetail;

        if (!isLoading && detail == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.rSp(context),
                ),
              ),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: _loadInitialData,
                child: Text(s.retry),
              ),
            ),
          );
        }

        final isSaving = state is EditAuctionSaving;

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.rSp(context),
                ),
              ),
              title: Text(
                s.auctionEditTitle,
                style: TextStyles.semiBold20(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadInitialData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isTabletOrUp ? 16.0 : 16.w,
                    isTabletOrUp ? 12.0 : 12.h,
                    isTabletOrUp ? 16.0 : 16.w,
                    isTabletOrUp ? 24.0 : 24.h,
                  ),
                  child: ResponsiveFormShell(
                    enabled: isTabletOrUp,
                    maxWidth: 700,
                    child: ResponsiveFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: s.auctionLotDetails),
                          SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                          Center(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: _pickHeadImage,
                                  borderRadius: BorderRadius.circular(
                                    12.rSp(context),
                                  ),
                                  child: Container(
                                    width: isTabletOrUp ? 156.0 : 156.w,
                                    padding: EdgeInsets.all(
                                      isTabletOrUp ? 12.0 : 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                        12.rSp(context),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFE4E4E4),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        10.rSp(context),
                                      ),
                                      child: _AuctionPreviewImage(
                                        imageUrl:
                                            displayDetail.image ??
                                            widget.args.item.imageUrl,
                                        localImage: _headImage,
                                        width: isTabletOrUp ? 100.0 : 100.w,
                                        height: isTabletOrUp ? 76.0 : 76.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                                Text(
                                  s.auctionTapToChangeImage,
                                  style: TextStyles.regular12(context).copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
                          _AuctionTextField(
                            controller: _lotTitleController,
                            hintText: s.auctionTitle,
                          ),
                          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                          _CategoryDropdown(
                            categories: categories,
                            value: _lotCategoryId,
                            onChanged: _onLotCategoryChanged,
                          ),
                          SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
                          ...List.generate(
                            _items.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: isTabletOrUp ? 14.0 : 14.h,
                              ),
                              child: _EditItemCard(
                                index: index + 1,
                                data: _items[index],
                                onPickImages: () => _pickItemImages(index),
                                imageUrl: _items[index].previewImages.isNotEmpty
                                    ? _items[index].previewImages.first
                                    : displayDetail.image ??
                                          widget.args.item.imageUrl,
                              ),
                            ),
                          ),
                          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                          _SectionLabel(label: s.auctionLotDescription),
                          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                          _AuctionTextField(
                            controller: _descriptionController,
                            hintText: s.kDescription,
                            minLines: 4,
                            maxLines: 4,
                          ),
                          SizedBox(height: isTabletOrUp ? 18.0 : 18.h),
                          SizedBox(
                            width: double.infinity,
                            height: isTabletOrUp ? 44.0 : 44.h,
                            child: ElevatedButton(
                              onPressed: isSaving ? null : _saveAuction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.rSp(context),
                                  ),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static final _dummyDetail = AuctionDetailModel(
    id: 0,
    title: 'Loading Auction Title...',
    description: 'Loading description...',
    image: null,
    startingPrice: 0,
    bidIncrement: 0,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 1)),
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

  String _cleanError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}

class _EditItemCard extends StatefulWidget {
  const _EditItemCard({
    required this.index,
    required this.data,
    required this.imageUrl,
    required this.onPickImages,
  });

  final int index;
  final _EditableItemData data;
  final String? imageUrl;
  final Future<void> Function() onPickImages;

  @override
  State<_EditItemCard> createState() => _EditItemCardState();
}

class _EditItemCardState extends State<_EditItemCard> {
  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.auctionItem} (${widget.index})',
          style: TextStyles.semiBold16(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
        Container(
          padding: EdgeInsets.all(isTabletOrUp ? 12.0 : 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.rSp(context)),
            border: Border.all(color: const Color(0xFFE4E4E4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...widget.data.previewImages.map(
                      (imageUrl) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: isTabletOrUp ? 8.0 : 8.w,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.rSp(context)),
                          child: _AuctionPreviewImage(
                            imageUrl: imageUrl,
                            width: isTabletOrUp ? 76.0 : 76.w,
                            height: isTabletOrUp ? 58.0 : 58.h,
                          ),
                        ),
                      ),
                    ),
                    ...widget.data.pickedImages.map(
                      (image) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: isTabletOrUp ? 8.0 : 8.w,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.rSp(context)),
                          child: _AuctionPreviewImage(
                            localImage: image,
                            width: isTabletOrUp ? 76.0 : 76.w,
                            height: isTabletOrUp ? 58.0 : 58.h,
                          ),
                        ),
                      ),
                    ),
                    if (widget.data.previewImages.isEmpty &&
                        widget.data.pickedImages.isEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: isTabletOrUp ? 8.0 : 8.w,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.rSp(context)),
                          child: _AuctionPreviewImage(
                            imageUrl: widget.imageUrl,
                            width: isTabletOrUp ? 76.0 : 76.w,
                            height: isTabletOrUp ? 58.0 : 58.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              InkWell(
                onTap: widget.onPickImages,
                child: Text(
                  s.auctionTapToAddImages,
                  style: TextStyles.regular12(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              Builder(
                builder: (context) {
                  final optionalAttributes = widget.data.attributesMeta
                      .where((a) => !a.isRequired)
                      .toList();
                  if (optionalAttributes.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: isTabletOrUp ? 12.0 : 12.h),
                    child: Wrap(
                      spacing: isTabletOrUp ? 8.0 : 8.w,
                      runSpacing: isTabletOrUp ? 8.0 : 8.h,
                      children: optionalAttributes.map((attribute) {
                        final controller =
                            widget.data.attributeControllers[attribute.id];
                        if (controller == null) return const SizedBox.shrink();
                        return _EditOptionalAttributeChip(
                          attribute: attribute,
                          controller: controller,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
              _AuctionTextField(
                controller: widget.data.titleController,
                hintText: s.auctionTitle,
              ),
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              _AuctionTextField(
                controller: widget.data.countController,
                hintText: s.auctionCount,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              _AuctionTextField(
                controller: widget.data.warrantyController,
                hintText: s.auctionWarrantyInfo,
              ),
              SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
              _AuctionTextField(
                controller: widget.data.descriptionController,
                hintText: s.kDescription,
                minLines: 3,
                maxLines: 3,
              ),
              SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
              Text(
                s.auctionCondition,
                style: TextStyles.regular12(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              Wrap(
                spacing: isTabletOrUp ? 12.0 : 12.w,
                runSpacing: isTabletOrUp ? 6.0 : 6.h,
                children: _AuctionCondition.values.map((condition) {
                  return InkWell(
                    onTap: () => setState(
                      () => widget.data.selectedCondition = condition,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: isTabletOrUp ? 14.0 : 14.w,
                          height: isTabletOrUp ? 14.0 : 14.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.data.selectedCondition == condition
                                  ? Theme.of(context).colorScheme.primary
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          child: widget.data.selectedCondition == condition
                              ? Center(
                                  child: Container(
                                    width: isTabletOrUp ? 8.0 : 8.w,
                                    height: isTabletOrUp ? 8.0 : 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: isTabletOrUp ? 6.0 : 6.w),
                        Text(
                          condition.label(context),
                          style: TextStyles.regular12(context),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Builder(
                builder: (context) {
                  if (widget.data.attributesMeta.isEmpty) {
                    if (widget.data.attributeControllers.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                        ...widget.data.attributeEntries.map(
                          (entry) => Padding(
                            padding: EdgeInsets.only(
                              bottom: isTabletOrUp ? 8.0 : 8.h,
                            ),
                            child: _AuctionTextField(
                              controller: entry.controller,
                              hintText: entry.label,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final requiredAttributes = widget.data.attributesMeta
                      .where((a) => a.isRequired)
                      .toList();
                  if (requiredAttributes.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                      Text(
                        s.auctionAttributes,
                        style: TextStyles.regular12(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                      ...requiredAttributes.map((attribute) {
                        final controller =
                            widget.data.attributeControllers[attribute.id];
                        if (controller == null) return const SizedBox.shrink();
                        final label = attribute.unitLabel.isEmpty
                            ? attribute.name
                            : '${attribute.name} (${attribute.unitLabel})';
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: isTabletOrUp ? 8.0 : 8.h,
                          ),
                          child: _AuctionTextField(
                            controller: controller,
                            hintText: '$label *',
                            keyboardType: attribute.isNumber
                                ? const TextInputType.numberWithOptions(
                                    decimal: true,
                                  )
                                : TextInputType.text,
                          ),
                        );
                      }),
                    ],
                  );
                },
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
    Breakpoints.isTabletOrUp(context);
    return Text(
      label,
      style: TextStyles.semiBold16(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTabletOrUp ? 10.0 : 10.w,
          vertical: isTabletOrUp ? 10.0 : 10.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.rSp(context)),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.rSp(context)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  final List<CategoryModel> categories;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 10.0 : 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.rSp(context)),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          hint: Text(
            categories.isEmpty ? 'No categories found' : 'Select category',
            style: TextStyles.regular13(
              context,
            ).copyWith(color: const Color(0xFF8A8A8A)),
          ),
          items: categories
              .map(
                (category) => DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: TextStyles.regular13(context),
                  ),
                ),
              )
              .toList(),
          onChanged: categories.isEmpty ? null : onChanged,
        ),
      ),
    );
  }
}

class _EditableItemData {
  _EditableItemData({
    required this.id,
    required this.categoryId,
    required String title,
    required String count,
    required String warrantyInfo,
    required String description,
    required this.selectedCondition,
    required this.previewImages,
    required this.attributeControllers,
  }) : attributesMeta = const [],
       titleController = TextEditingController(text: title),
       countController = TextEditingController(text: count),
       warrantyController = TextEditingController(text: warrantyInfo),
       descriptionController = TextEditingController(text: description),
       pickedImages = [];

  factory _EditableItemData.fromDetail(AuctionDetailItemModel item) {
    return _EditableItemData(
      id: item.id,
      categoryId: item.categoryId,
      title: item.title,
      count: item.count.toString(),
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
  int categoryId;
  final TextEditingController titleController;
  final TextEditingController countController;
  final TextEditingController warrantyController;
  final TextEditingController descriptionController;
  final List<String> previewImages;
  final List<XFile> pickedImages;
  final Map<int, TextEditingController> attributeControllers;
  List<CategoryAttributeModel> attributesMeta;
  _AuctionCondition selectedCondition;

  List<_EditableAttributeEntry> get attributeEntries {
    if (attributesMeta.isEmpty) {
      return attributeControllers.entries
          .map(
            (entry) => _EditableAttributeEntry(
              label: entry.key.toString(),
              controller: entry.value,
            ),
          )
          .toList();
    }

    return attributesMeta
        .where((attribute) => attributeControllers.containsKey(attribute.id))
        .map(
          (attribute) => _EditableAttributeEntry(
            label: attribute.unitLabel.isEmpty
                ? attribute.name
                : '${attribute.name} (${attribute.unitLabel})',
            controller: attributeControllers[attribute.id]!,
          ),
        )
        .toList();
  }

  void syncAttributes(
    List<CategoryAttributeModel> attributes, {
    bool preserveExistingValues = false,
  }) {
    final existingValues = {
      for (final entry in attributeControllers.entries)
        entry.key: entry.value.text,
    };
    final allowedIds = attributes.map((attribute) => attribute.id).toSet();
    attributeControllers.removeWhere((key, controller) {
      final shouldRemove = !allowedIds.contains(key);
      if (shouldRemove) {
        controller.dispose();
      }
      return shouldRemove;
    });

    for (final attribute in attributes) {
      attributeControllers.putIfAbsent(
        attribute.id,
        () => TextEditingController(
          text: preserveExistingValues
              ? (existingValues[attribute.id] ?? '')
              : '',
        ),
      );
    }

    attributesMeta = List<CategoryAttributeModel>.from(attributes);
  }

  void dispose() {
    titleController.dispose();
    countController.dispose();
    warrantyController.dispose();
    descriptionController.dispose();
    for (final controller in attributeControllers.values) {
      controller.dispose();
    }
  }
}

class _EditableAttributeEntry {
  final String label;
  final TextEditingController controller;

  const _EditableAttributeEntry({
    required this.label,
    required this.controller,
  });
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
    this.imageUrl,
    required this.width,
    required this.height,
    this.localImage,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final XFile? localImage;

  @override
  Widget build(BuildContext context) {
    Breakpoints.isTabletOrUp(context);
    if (localImage != null) {
      return FutureBuilder<Uint8List>(
        future: localImage!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: width,
              height: height,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return _placeholder();
        },
      );
    }

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

IconData _getIconForAttribute(String name) {
  final lowerName = name.toLowerCase();
  if (lowerName.contains('weight') || lowerName.contains('وزن')) {
    return Icons.scale;
  }
  if (lowerName.contains('furnish') || lowerName.contains('مفروش')) {
    return Icons.chair;
  }
  if (lowerName.contains('floor') || lowerName.contains('طابق')) {
    return Icons.layers;
  }
  if (lowerName.contains('material') ||
      lowerName.contains('مادة') ||
      lowerName.contains('خام')) {
    return Icons.texture;
  }
  if (lowerName.contains('color') || lowerName.contains('لون')) {
    return Icons.color_lens;
  }
  if (lowerName.contains('page') || lowerName.contains('صفح')) {
    return Icons.auto_stories;
  }
  if (lowerName.contains(RegExp(r'\bage\b')) || lowerName.contains('عمر')) {
    return Icons.supervisor_account;
  }
  if (lowerName.contains('battery') || lowerName.contains('بطار')) {
    return Icons.battery_charging_full;
  }
  if (lowerName.contains('dimension') || lowerName.contains('أبعاد')) {
    return Icons.straighten;
  }
  if (lowerName.contains('location') || lowerName.contains('موقع')) {
    return Icons.public;
  }
  if (lowerName.contains('model') || lowerName.contains('موديل')) {
    return Icons.directions_car;
  }
  if (lowerName.contains('gear') ||
      lowerName.contains('transmission') ||
      lowerName.contains('ناقل')) {
    return Icons.settings;
  }
  if (lowerName.contains('fuel') ||
      lowerName.contains('petrol') ||
      lowerName.contains('وقود')) {
    return Icons.local_gas_station;
  }
  if (lowerName.contains('speed') ||
      lowerName.contains('mileage') ||
      lowerName.contains('سرع')) {
    return Icons.speed;
  }
  if (lowerName.contains('brand') || lowerName.contains('ماركة')) {
    return Icons.branding_watermark;
  }
  if (lowerName.contains('capacity') || lowerName.contains('سعة')) {
    return Icons.sd_storage;
  }
  if (lowerName.contains('screen') || lowerName.contains('شاش')) {
    return Icons.desktop_windows;
  }
  if (lowerName.contains('area') || lowerName.contains('مساح')) {
    return Icons.crop_square;
  }
  if (lowerName.contains('room') || lowerName.contains('غرف')) {
    return Icons.meeting_room;
  }
  if (lowerName.contains('size') || lowerName.contains('حجم')) {
    return Icons.photo_size_select_small;
  }
  if (lowerName.contains('author') || lowerName.contains('مؤلف')) {
    return Icons.person;
  }
  if (lowerName.contains('language') || lowerName.contains('لغ')) {
    return Icons.language;
  }
  if (lowerName.contains('publisher') || lowerName.contains('ناشر')) {
    return Icons.print;
  }

  return Icons.label_outline;
}

class _EditOptionalAttributeChip extends StatelessWidget {
  const _EditOptionalAttributeChip({
    required this.attribute,
    required this.controller,
  });

  final CategoryAttributeModel attribute;
  final TextEditingController controller;

  void _handleTap(BuildContext context) {
    if (attribute.isBoolean) {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(attribute.name, style: TextStyles.semiBold16(context)),
          children: [
            SimpleDialogOption(
              onPressed: () {
                controller.text = 'true';
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).kYes,
                style: TextStyles.regular13(context),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                controller.text = 'false';
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).kNo,
                style: TextStyles.regular13(context),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (attribute.isDate || attribute.isDateTime) {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      ).then((date) {
        if (date != null) {
          controller.text =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        }
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attribute.name, style: TextStyles.semiBold16(context)),
        content: TextField(
          controller: controller,
          keyboardType: attribute.isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: TextStyles.regular13(context),
          decoration: InputDecoration(hintText: attribute.name, isDense: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).kSave),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasValue = value.text.isNotEmpty;
        String displayValue = hasValue ? value.text : '${attribute.name} +';

        if (attribute.isBoolean && hasValue) {
          displayValue = value.text.toLowerCase() == 'true' ? s.kYes : s.kNo;
        }

        return InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(6.rSp(context)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrUp ? 10.0 : 10.w,
              vertical: isTabletOrUp ? 6.0 : 6.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E4)),
              borderRadius: BorderRadius.circular(6.rSp(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForAttribute(attribute.name),
                  size: isTabletOrUp ? 16.0 : 16.rSp(context),
                  color: hasValue
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF8A8A8A),
                ),
                SizedBox(width: isTabletOrUp ? 6.0 : 6.w),
                Text(
                  displayValue,
                  style: TextStyles.regular12(context).copyWith(
                    color: hasValue
                        ? Theme.of(context).colorScheme.onSurface
                        : const Color(0xFF8A8A8A),
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
