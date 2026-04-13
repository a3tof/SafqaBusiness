import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/view/price_duration_view.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model_state.dart';

class LotAuctionView extends StatelessWidget {
  const LotAuctionView({super.key});

  static const String routeName = 'lotAuctionView';

  @override
  Widget build(BuildContext context) {
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
    if (_lotTitleController.text.trim().isEmpty) {
      _showMessage('Please enter the lot title.');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showMessage('Please enter the lot description.');
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
        _showMessage('Please enter a title for item ${index + 1}.');
        return false;
      }
      if (countText.isEmpty) {
        _showMessage('Please enter a count for item ${index + 1}.');
        return false;
      }
      final count = int.tryParse(countText);
      if (count == null || count <= 0) {
        _showMessage('Please enter a valid count for item ${index + 1}.');
        return false;
      }
      if (itemDescription.isEmpty) {
        _showMessage('Please enter a description for item ${index + 1}.');
        return false;
      }
      if (warrantyInfo.isEmpty) {
        _showMessage('Please enter warranty info for item ${index + 1}.');
        return false;
      }
      if (categoryId == null) {
        _showMessage('Please select a category for item ${index + 1}.');
        return false;
      }
      if (attributeError != null) {
        _showMessage(
          'Could not load attributes for item ${index + 1}. Please retry or choose another category.',
        );
        return false;
      }
      if (loadedAttributes.isEmpty) {
        _showMessage(
          'The selected category for item ${index + 1} has no loaded attributes, and the API requires them.',
        );
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
                'Please enter a valid number for ${attribute.name} in item ${index + 1}.',
              );
              return false;
            }
            value = normalizedValue;
          }
        }

        if (attribute.isRequired && (value == null || value.isEmpty)) {
          _showMessage(
            'Please provide ${attribute.name} for item ${index + 1}.',
          );
          return false;
        }

        if (value != null && value.isNotEmpty) {
          attributes.add(
            ItemAttributeValueModel(
              categoryAttributeId: attribute.id,
              value: value,
            ),
          );
          continue;
        }

        // Keep the collection bound on the backend even for optional blanks.
        attributes.add(
          ItemAttributeValueModel(categoryAttributeId: attribute.id, value: ''),
        );
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
        durationInDays: 0,
        headImage: _headImage,
        items: items,
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAuctionViewModel, CreateAuctionViewModelState>(
      listener: (context, state) {
        if (state is AttributesLoaded) {
          setState(() {
            _syncAttributesForItem(state.itemIndex, state.attributes);
          });
        } else if (state is AttributesUnavailable) {
          setState(() {
            _syncAttributesForItem(state.itemIndex, const []);
          });
          _showMessage(
            'Could not load category attributes for this item. Try another category or retry later.',
          );
        } else if (state is CreateAuctionFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateAuctionViewModel>();
        final categories = cubit.categories;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context: context, title: 'Lot Auction'),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'Lot Details'),
                  SizedBox(height: 8.h),
                  _UploadBox(
                    label: _headImage == null
                        ? 'Head Image +'
                        : 'Selected: ${_headImage!.name}',
                    height: 88,
                    onTap: _pickHeadImage,
                  ),
                  SizedBox(height: 10.h),
                  const _FieldLabel(label: 'Lot Title'),
                  SizedBox(height: 4.h),
                  _AuctionTextField(controller: _lotTitleController),
                  SizedBox(height: 8.h),
                  Text(
                    categories.isEmpty && state is CategoriesLoading
                        ? 'Loading categories...'
                        : 'Select a category for each item below.',
                    style: TextStyles.regular11(
                      context,
                    ).copyWith(color: const Color(0xFF8A8A8A)),
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate(
                    _items.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
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
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),
                      label: Text(
                        'Add Item',
                        style: TextStyles.semiBold13(
                          context,
                        ).copyWith(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const _SectionLabel(label: 'Lot Description'),
                  SizedBox(height: 8.h),
                  _AuctionTextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 3,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
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
                  SizedBox(height: 12.h),
                  _PrimaryButton(
                    label: 'Save & Continue',
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
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SectionLabel(label: 'Item ($index)')),
              if (onRemove != null)
                TextButton(
                  onPressed: onRemove,
                  child: Text(
                    'Remove',
                    style: TextStyles.regular12(
                      context,
                    ).copyWith(color: Colors.red),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          _UploadBox(
            label: item.images.isEmpty
                ? 'Add Images +'
                : '${item.images.length} image(s) selected',
            height: 82,
            onTap: onPickImages,
          ),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Title'),
          SizedBox(height: 4.h),
          _AuctionTextField(controller: item.titleController),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Count'),
          SizedBox(height: 4.h),
          _AuctionTextField(
            controller: item.countController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Description'),
          SizedBox(height: 4.h),
          _AuctionTextField(
            controller: item.descriptionController,
            minLines: 2,
            maxLines: 2,
          ),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Warranty Info'),
          SizedBox(height: 4.h),
          _AuctionTextField(controller: item.warrantyController),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Category'),
          SizedBox(height: 4.h),
          _CategoryDropdown(
            categories: categories,
            value: item.categoryId,
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 8.h),
          const _FieldLabel(label: 'Condition'),
          SizedBox(height: 4.h),
          _ConditionRow(
            selected: item.condition,
            onChanged: onConditionChanged,
          ),
          if (attributes.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const _FieldLabel(label: 'Attributes'),
            SizedBox(height: 6.h),
            ...attributes.map(
              (attribute) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
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
    return Text(
      label,
      style: TextStyles.semiBold16(context).copyWith(color: Colors.black),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
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
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
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
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyles.regular13(context),
      decoration: InputDecoration(
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

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.selected, required this.onChanged});

  final _Condition selected;
  final ValueChanged<_Condition> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 6.h,
      children: _Condition.values.map((condition) {
        return InkWell(
          onTap: () => onChanged(condition),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == condition
                        ? AppColors.primaryColor
                        : const Color(0xFFBDBDBD),
                  ),
                ),
                child: selected == condition
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
              Text(condition.label, style: TextStyles.regular12(context)),
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
    return SizedBox(
      width: double.infinity,
      height: 42.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
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
  newItem('New'),
  usedLikeNew('Used-Like New'),
  used('Used');

  const _Condition(this.label);

  final String label;

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
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
    final label = attribute.unitLabel.isEmpty
        ? attribute.name
        : '${attribute.name} (${attribute.unitLabel})';

    if (attribute.isBoolean) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: attribute.isRequired ? '$label *' : label),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFFE4E4E4)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                value: item.booleanAttributes[attribute.id],
                isExpanded: true,
                hint: Text(
                  'Select value',
                  style: TextStyles.regular13(
                    context,
                  ).copyWith(color: const Color(0xFF8A8A8A)),
                ),
                items: const [
                  DropdownMenuItem<bool>(value: true, child: Text('True')),
                  DropdownMenuItem<bool>(value: false, child: Text('False')),
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
          SizedBox(height: 4.h),
          _UploadBox(
            label: currentValue?.isNotEmpty == true
                ? currentValue!
                : attribute.isDateTime
                ? 'Select date & time'
                : 'Select date',
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
        SizedBox(height: 4.h),
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
