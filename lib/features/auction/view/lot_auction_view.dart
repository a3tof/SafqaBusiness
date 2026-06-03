import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/view/price_duration_view.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class LotAuctionView extends StatelessWidget {
  const LotAuctionView({super.key});

  static const String routeName = 'lotAuctionView';

  @override
  Widget build(BuildContext context) {
    Breakpoints.isTabletOrUp(context);
    return BlocProvider(
      create: (_) => getIt<CreateAuctionViewModel>()..loadCategories(),
      child: const _LotAuctionViewBody(),
    );
  }
}

class _LotAuctionViewBody extends StatefulWidget {
  const _LotAuctionViewBody();

  @override
  State<_LotAuctionViewBody> createState() => _LotAuctionViewBodyState();
}

class _LotAuctionViewBodyState extends State<_LotAuctionViewBody> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _lotTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<_LotItemFormData> _items = [_LotItemFormData()];
  XFile? _headImage;

  @override
  void dispose() {
    _lotTitleController.dispose();
    _descriptionController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _syncAttributesForItem(
    int itemIndex,
    List<CategoryAttributeModel> attributes,
  ) {
    if (itemIndex < 0 || itemIndex >= _items.length) {
      return;
    }
    _items[itemIndex].syncAttributes(attributes);
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
    setState(() => _items[itemIndex].images = images);
  }

  Future<void> _pickDateValue({
    required int itemIndex,
    required CategoryAttributeModel attribute,
  }) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (selectedDate == null || !mounted) {
      return;
    }

    if (attribute.isDateTime) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (selectedTime == null || !mounted) {
        return;
      }
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        _items[itemIndex].dateTimeAttributes[attribute.id] = selectedDateTime
            .toIso8601String();
      });
      return;
    }

    setState(() {
      _items[itemIndex].dateTimeAttributes[attribute.id] = selectedDate
          .toIso8601String()
          .split('T')
          .first;
    });
  }

  void _addItem() {
    setState(() => _items.add(_LotItemFormData()));
  }

  void _removeItem(int itemIndex) {
    if (_items.length == 1) {
      return;
    }
    setState(() {
      _items.removeAt(itemIndex).dispose();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateAndStoreDraft() {
    final s = S.of(context);
    if (_lotTitleController.text.trim().isEmpty) {
      _showMessage(s.auctionEnterLotTitle);
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showMessage(s.auctionEnterLotDescription);
      return false;
    }

    final cubit = context.read<CreateAuctionViewModel>();
    final items = <AuctionItemModel>[];

    for (var index = 0; index < _items.length; index++) {
      final item = _items[index];
      final title = item.titleController.text.trim();
      final countText = item.countController.text.trim();
      final itemDescription = item.descriptionController.text.trim();
      final warrantyInfo = item.warrantyController.text.trim();
      final categoryId = item.categoryId;
      final loadedAttributes = cubit.attributesForItem(index);
      final attributeError = cubit.attributeErrorForItem(index);

      if (title.isEmpty) {
        _showMessage(s.auctionEnterItemTitle(index + 1));
        return false;
      }
      if (countText.isEmpty) {
        _showMessage(s.auctionEnterItemCount(index + 1));
        return false;
      }
      final count = int.tryParse(countText);
      if (count == null || count <= 0) {
        _showMessage(s.auctionEnterValidItemCount(index + 1));
        return false;
      }
      if (itemDescription.isEmpty) {
        _showMessage(s.auctionEnterItemDescription(index + 1));
        return false;
      }
      if (warrantyInfo.isEmpty) {
        _showMessage(s.auctionEnterItemWarrantyInfo(index + 1));
        return false;
      }
      if (categoryId == null) {
        _showMessage(s.auctionSelectItemCategory(index + 1));
        return false;
      }
      if (attributeError != null) {
        _showMessage(s.auctionItemAttributesLoadError(index + 1));
        return false;
      }

      final attributes = <ItemAttributeValueModel>[];
      for (final attribute in loadedAttributes) {
        String? value;
        if (attribute.isBoolean) {
          final selected = item.booleanAttributes[attribute.id];
          value = selected?.toString();
        } else if (attribute.isDate || attribute.isDateTime) {
          value = item.dateTimeAttributes[attribute.id]?.trim();
        } else {
          value = item.attributeControllers[attribute.id]?.text.trim();
          if (attribute.isNumber && value != null && value.isNotEmpty) {
            final normalizedValue = value.replaceAll(',', '');
            if (double.tryParse(normalizedValue) == null) {
              _showMessage(
                s.auctionInvalidNumberForItemAttribute(
                  attribute.name,
                  index + 1,
                ),
              );
              return false;
            }
            value = normalizedValue;
          }
        }

        if (attribute.isRequired && (value == null || value.isEmpty)) {
          _showMessage(
            s.auctionProvideItemAttribute(attribute.name, index + 1),
          );
          return false;
        }

        final trimmedValue = value?.trim();
        if (trimmedValue != null && trimmedValue.isNotEmpty) {
          attributes.add(
            ItemAttributeValueModel(
              categoryAttributeId: attribute.id,
              value: trimmedValue,
            ),
          );
        }
      }

      items.add(
        AuctionItemModel(
          title: title,
          count: count,
          description: itemDescription,
          warrantyInfo: warrantyInfo,
          condition: item.condition.apiValue,
          categoryId: categoryId,
          images: item.images,
          attributes: attributes,
        ),
      );
    }

    cubit.setDraftRequest(
      CreateAuctionRequestModel(
        title: _lotTitleController.text.trim(),
        description: _descriptionController.text.trim(),
        startingPrice: 0,
        bidIncrement: 0,
        startDate: null,
        endDate: null,
        headImage: _headImage,
        items: items,
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BlocConsumer<CreateAuctionViewModel, CreateAuctionViewModelState>(
      listener: (context, state) {
        final s = S.of(context);
        if (state is AttributesLoaded) {
          setState(() {
            _syncAttributesForItem(state.itemIndex, state.attributes);
          });
        } else if (state is AttributesUnavailable) {
          setState(() {
            _syncAttributesForItem(state.itemIndex, const []);
          });
          _showMessage(s.auctionLoadCategoryAttributesForItemError);
        } else if (state is CreateAuctionFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final s = S.of(context);
        final cubit = context.read<CreateAuctionViewModel>();
        final categories = cubit.categories;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: buildAppBar(
            context: context,
            title: s.auctionLotAuctionTitle,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
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
                      SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                      _UploadBox(
                        label: _headImage == null
                            ? s.auctionHeadImage
                            : s.auctionSelectedFile(_headImage!.name),
                        height: 88,
                        onTap: _pickHeadImage,
                      ),
                      SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                      _FieldLabel(label: s.auctionTitle),
                      SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
                      _AuctionTextField(controller: _lotTitleController),
                      SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                      Text(
                        categories.isEmpty && state is CategoriesLoading
                            ? s.auctionLoadingCategories
                            : s.auctionSelectCategoryPerItem,
                        style: TextStyles.regular11(
                          context,
                        ).copyWith(color: const Color(0xFF8A8A8A)),
                      ),
                      SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
                      ...List.generate(
                        _items.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: isTabletOrUp ? 14.0 : 14.h,
                          ),
                          child: _LotItemCard(
                            index: index + 1,
                            item: _items[index],
                            categories: categories,
                            attributes: cubit.attributesForItem(index),
                            onPickImages: () => _pickItemImages(index),
                            onRemove: _items.length > 1
                                ? () => _removeItem(index)
                                : null,
                            onConditionChanged: (value) {
                              setState(() => _items[index].condition = value);
                            },
                            onCategoryChanged: (value) async {
                              setState(() {
                                _items[index].categoryId = value;
                                _items[index].clearDynamicValues();
                              });
                              if (value != null) {
                                await cubit.loadAttributes(
                                  itemIndex: index,
                                  categoryId: value,
                                );
                              } else {
                                cubit.clearItemAttributes(index);
                              }
                            },
                            onBooleanChanged: (attributeId, value) {
                              setState(() {
                                _items[index].booleanAttributes[attributeId] =
                                    value;
                              });
                            },
                            onPickDate: (attribute) => _pickDateValue(
                              itemIndex: index,
                              attribute: attribute,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton.icon(
                          onPressed: _addItem,
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            size: 18.rSp(context),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(
                            s.auctionAddItem,
                            style: TextStyles.semiBold13(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
                      _SectionLabel(label: s.auctionLotDescription),
                      SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
                      _AuctionTextField(
                        controller: _descriptionController,
                        minLines: 3,
                        maxLines: 3,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: isTabletOrUp ? 4.0 : 4.h,
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _descriptionController,
                            builder: (context, value, _) {
                              return Text(
                                '${value.text.length}/160',
                                style: TextStyles.regular11(
                                  context,
                                ).copyWith(color: const Color(0xFF888888)),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
                      _PrimaryButton(
                        label: s.auctionSaveContinue,
                        onTap: () {
                          if (!_validateAndStoreDraft()) {
                            return;
                          }
                          Navigator.pushNamed(
                            context,
                            PriceDurationView.routeName,
                            arguments: cubit,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LotItemCard extends StatelessWidget {
  const _LotItemCard({
    required this.index,
    required this.item,
    required this.categories,
    required this.attributes,
    required this.onPickImages,
    required this.onConditionChanged,
    required this.onCategoryChanged,
    required this.onBooleanChanged,
    required this.onPickDate,
    this.onRemove,
  });

  final int index;
  final _LotItemFormData item;
  final List<CategoryModel> categories;
  final List<CategoryAttributeModel> attributes;
  final VoidCallback onPickImages;
  final VoidCallback? onRemove;
  final ValueChanged<_Condition> onConditionChanged;
  final ValueChanged<int?> onCategoryChanged;
  final void Function(int attributeId, bool? value) onBooleanChanged;
  final ValueChanged<CategoryAttributeModel> onPickDate;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);
    return Container(
      padding: EdgeInsets.all(isTabletOrUp ? 12.0 : 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.rSp(context)),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _SectionLabel(label: '${s.auctionItem} ($index)'),
              ),
              if (onRemove != null)
                TextButton(
                  onPressed: onRemove,
                  child: Text(
                    s.auctionRemove,
                    style: TextStyles.regular12(
                      context,
                    ).copyWith(color: Colors.red),
                  ),
                ),
            ],
          ),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _UploadBox(
            label: item.images.isEmpty
                ? s.auctionAddImages
                : s.auctionSelectedImagesCount(item.images.length),
            height: 82,
            onTap: onPickImages,
          ),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.auctionTitle),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _AuctionTextField(controller: item.titleController),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.auctionCount),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _AuctionTextField(
            controller: item.countController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.kDescription),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _AuctionTextField(
            controller: item.descriptionController,
            minLines: 2,
            maxLines: 2,
          ),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.auctionWarrantyInfo),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _AuctionTextField(controller: item.warrantyController),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.auctionCategory),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _CategoryDropdown(
            categories: categories,
            value: item.categoryId,
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
          _FieldLabel(label: s.auctionCondition),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _ConditionRow(
            selected: item.condition,
            onChanged: onConditionChanged,
          ),
          if (attributes.isNotEmpty) ...[
            SizedBox(height: isTabletOrUp ? 10.0 : 10.h),
            _FieldLabel(label: s.auctionAttributes),
            SizedBox(height: isTabletOrUp ? 6.0 : 6.h),
            ...attributes.map(
              (attribute) => Padding(
                padding: EdgeInsets.only(bottom: isTabletOrUp ? 8.0 : 8.h),
                child: _AttributeField(
                  attribute: attribute,
                  item: item,
                  onBooleanChanged: onBooleanChanged,
                  onPickDate: () => onPickDate(attribute),
                ),
              ),
            ),
          ],
        ],
      ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    Breakpoints.isTabletOrUp(context);
    return Text(
      label,
      style: TextStyles.regular11(
        context,
      ).copyWith(color: const Color(0xFF8A8A8A)),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.label,
    required this.height,
    required this.onTap,
  });

  final String label;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Breakpoints.isTabletOrUp(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.rSp(context)),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.regular12(
              context,
            ).copyWith(color: const Color(0xFF9A9A9A)),
          ),
        ),
      ),
    );
  }
}

class _AuctionTextField extends StatelessWidget {
  const _AuctionTextField({
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController? controller;
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
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTabletOrUp ? 10.0 : 10.w,
          vertical: isTabletOrUp ? 10.0 : 10.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.rSp(context)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.rSp(context)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.selected, required this.onChanged});

  final _Condition selected;
  final ValueChanged<_Condition> onChanged;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);
    return Wrap(
      spacing: isTabletOrUp ? 10.0 : 10.w,
      runSpacing: isTabletOrUp ? 6.0 : 6.h,
      children: _Condition.values.map((condition) {
        return InkWell(
          onTap: () => onChanged(condition),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isTabletOrUp ? 14.0 : 14.w,
                height: isTabletOrUp ? 14.0 : 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == condition
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFFBDBDBD),
                  ),
                ),
                child: selected == condition
                    ? Center(
                        child: Container(
                          width: isTabletOrUp ? 8.0 : 8.w,
                          height: isTabletOrUp ? 8.0 : 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: isTabletOrUp ? 6.0 : 6.w),
              Text(
                condition.localizedLabel(s),
                style: TextStyles.regular12(context),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return SizedBox(
      width: double.infinity,
      height: isTabletOrUp ? 42.0 : 42.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.rSp(context)),
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

enum _Condition {
  newItem,
  usedLikeNew,
  used;

  String localizedLabel(S s) {
    switch (this) {
      case _Condition.newItem:
        return s.auctionNew;
      case _Condition.usedLikeNew:
        return s.auctionUsedLikeNew;
      case _Condition.used:
        return s.auctionUsed;
    }
  }

  int get apiValue {
    switch (this) {
      case _Condition.newItem:
        return 1;
      case _Condition.usedLikeNew:
        return 2;
      case _Condition.used:
        return 3;
    }
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
            categories.isEmpty
                ? S.of(context).auctionNoCategoriesFound
                : S.of(context).auctionSelectCategoryHint,
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

class _AttributeField extends StatelessWidget {
  const _AttributeField({
    required this.attribute,
    required this.item,
    required this.onBooleanChanged,
    required this.onPickDate,
  });

  final CategoryAttributeModel attribute;
  final _LotItemFormData item;
  final void Function(int attributeId, bool? value) onBooleanChanged;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final s = S.of(context);
    final label = attribute.unitLabel.isEmpty
        ? attribute.name
        : '${attribute.name} (${attribute.unitLabel})';

    if (attribute.isBoolean) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: attribute.isRequired ? '$label *' : label),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTabletOrUp ? 10.0 : 10.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.rSp(context)),
              border: Border.all(color: const Color(0xFFE4E4E4)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                value: item.booleanAttributes[attribute.id],
                isExpanded: true,
                hint: Text(
                  s.auctionSelectValue,
                  style: TextStyles.regular13(
                    context,
                  ).copyWith(color: const Color(0xFF8A8A8A)),
                ),
                items: [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text(s.auctionTrue),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text(s.auctionFalse),
                  ),
                ],
                onChanged: (value) => onBooleanChanged(attribute.id, value),
              ),
            ),
          ),
        ],
      );
    }

    if (attribute.isDate || attribute.isDateTime) {
      final currentValue = item.dateTimeAttributes[attribute.id];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: attribute.isRequired ? '$label *' : label),
          SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
          _UploadBox(
            label: currentValue?.isNotEmpty == true
                ? currentValue!
                : attribute.isDateTime
                ? s.auctionSelectDateTime
                : s.auctionSelectDate,
            height: 50,
            onTap: onPickDate,
          ),
        ],
      );
    }

    final controller = item.attributeControllers.putIfAbsent(
      attribute.id,
      () => TextEditingController(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: attribute.isRequired ? '$label *' : label),
        SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
        _AuctionTextField(
          controller: controller,
          keyboardType: attribute.isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
        ),
      ],
    );
  }
}

class _LotItemFormData {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final Map<int, TextEditingController> attributeControllers = {};
  final Map<int, bool?> booleanAttributes = {};
  final Map<int, String> dateTimeAttributes = {};

  _Condition condition = _Condition.newItem;
  int? categoryId;
  List<XFile> images = const [];

  void clearDynamicValues() {
    for (final controller in attributeControllers.values) {
      controller.dispose();
    }
    attributeControllers.clear();
    booleanAttributes.clear();
    dateTimeAttributes.clear();
  }

  void syncAttributes(List<CategoryAttributeModel> attributes) {
    final allowedIds = attributes.map((attribute) => attribute.id).toSet();
    attributeControllers.removeWhere((key, controller) {
      final shouldRemove = !allowedIds.contains(key);
      if (shouldRemove) {
        controller.dispose();
      }
      return shouldRemove;
    });
    booleanAttributes.removeWhere((key, _) => !allowedIds.contains(key));
    dateTimeAttributes.removeWhere((key, _) => !allowedIds.contains(key));

    for (final attribute in attributes) {
      if (attribute.isTextLike || attribute.isNumber) {
        attributeControllers.putIfAbsent(
          attribute.id,
          () => TextEditingController(),
        );
      } else if (attribute.isBoolean) {
        booleanAttributes.putIfAbsent(attribute.id, () => null);
      }
    }
  }

  void dispose() {
    titleController.dispose();
    countController.dispose();
    descriptionController.dispose();
    warrantyController.dispose();
    clearDynamicValues();
  }
}
