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

class ItemAuctionView extends StatelessWidget {
  const ItemAuctionView({super.key});

  static const String routeName = 'itemAuctionView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateAuctionViewModel>()..loadCategories(),
      child: const _ItemAuctionViewBody(),
    );
  }
}

class _ItemAuctionViewBody extends StatefulWidget {
  const _ItemAuctionViewBody();

  @override
  State<_ItemAuctionViewBody> createState() => _ItemAuctionViewBodyState();
}

class _ItemAuctionViewBodyState extends State<_ItemAuctionViewBody> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Map<int, TextEditingController> _attributeControllers = {};
  final Map<int, bool?> _booleanAttributes = {};
  final Map<int, String> _dateTimeAttributes = {};

  _Condition _selectedCondition = _Condition.newItem;
  XFile? _headImage;
  int? _categoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _warrantyController.dispose();
    _descriptionController.dispose();
    for (final controller in _attributeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickHeadImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) {
      return;
    }
    setState(() => _headImage = image);
  }

  Future<void> _pickDateValue(CategoryAttributeModel attribute) async {
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
        _dateTimeAttributes[attribute.id] = selectedDateTime.toIso8601String();
      });
      return;
    }

    setState(() {
      _dateTimeAttributes[attribute.id] = selectedDate
          .toIso8601String()
          .split('T')
          .first;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _syncAttributes(List<CategoryAttributeModel> attributes) {
    final allowedIds = attributes.map((attribute) => attribute.id).toSet();

    _attributeControllers.removeWhere((key, controller) {
      final shouldRemove = !allowedIds.contains(key);
      if (shouldRemove) {
        controller.dispose();
      }
      return shouldRemove;
    });
    _booleanAttributes.removeWhere((key, _) => !allowedIds.contains(key));
    _dateTimeAttributes.removeWhere((key, _) => !allowedIds.contains(key));

    for (final attribute in attributes) {
      if (attribute.isTextLike || attribute.isNumber) {
        _attributeControllers.putIfAbsent(
          attribute.id,
          () => TextEditingController(),
        );
      } else if (attribute.isBoolean) {
        _booleanAttributes.putIfAbsent(attribute.id, () => null);
      }
    }
  }

  bool _validateAndStoreDraft() {
    final cubit = context.read<CreateAuctionViewModel>();
    final attributesMeta = cubit.attributesForItem(0);
    final attributeError = cubit.attributeErrorForItem(0);

    if (_headImage == null) {
      _showMessage('اختار صورة المنتج الأول.');
      return false;
    }
    if (_titleController.text.trim().isEmpty) {
      _showMessage('Please enter the item title.');
      return false;
    }
    if (_categoryId == null) {
      _showMessage('Please select a category.');
      return false;
    }
    if (_warrantyController.text.trim().isEmpty) {
      _showMessage('Please enter warranty info.');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showMessage('Please enter the description.');
      return false;
    }
    if (attributeError != null) {
      _showMessage('Could not load category attributes. Try another category.');
      return false;
    }
    if (attributesMeta.isEmpty) {
      _showMessage(
        'This category has no loaded attributes, and the API requires them.',
      );
      return false;
    }

    final attributes = <ItemAttributeValueModel>[];
    for (final attribute in attributesMeta) {
      String? value;
      if (attribute.isBoolean) {
        value = _booleanAttributes[attribute.id]?.toString();
      } else if (attribute.isDate || attribute.isDateTime) {
        value = _dateTimeAttributes[attribute.id]?.trim();
      } else {
        value = _attributeControllers[attribute.id]?.text.trim();
        if (attribute.isNumber && value != null && value.isNotEmpty) {
          final normalizedValue = value.replaceAll(',', '');
          if (double.tryParse(normalizedValue) == null) {
            _showMessage('Please enter a valid number for ${attribute.name}.');
            return false;
          }
          value = normalizedValue;
        }
      }

      if (attribute.isRequired && (value == null || value.isEmpty)) {
        _showMessage('Please provide ${attribute.name}.');
        return false;
      }

      attributes.add(
        ItemAttributeValueModel(
          categoryAttributeId: attribute.id,
          value: (value ?? '').trim(),
        ),
      );
    }

    cubit.setDraftRequest(
      CreateAuctionRequestModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startingPrice: 0,
        bidIncrement: 0,
        durationInDays: 0,
        headImage: _headImage,
        items: [
          AuctionItemModel(
            title: _titleController.text.trim(),
            count: 1,
            description: _descriptionController.text.trim(),
            warrantyInfo: _warrantyController.text.trim(),
            condition: _selectedCondition.apiValue,
            categoryId: _categoryId!,
            images: [_headImage!],
            attributes: attributes,
          ),
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAuctionViewModel, CreateAuctionViewModelState>(
      listener: (context, state) {
        if (state is AttributesLoaded && state.itemIndex == 0) {
          setState(() => _syncAttributes(state.attributes));
        } else if (state is AttributesUnavailable && state.itemIndex == 0) {
          setState(() => _syncAttributes(const []));
          _showMessage('Could not load category attributes for this item.');
        } else if (state is CreateAuctionFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateAuctionViewModel>();
        final categories = cubit.categories;
        final attributes = cubit.attributesForItem(0);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context: context, title: 'Item Auction'),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UploadBox(
                    label: _headImage == null
                        ? 'Head Image +'
                        : 'Selected: ${_headImage!.name}',
                    onTap: _pickHeadImage,
                  ),
                  SizedBox(height: 10.h),
                  const _FieldLabel(label: 'Title'),
                  SizedBox(height: 4.h),
                  _AuctionTextField(controller: _titleController),
                  SizedBox(height: 10.h),
                  const _FieldLabel(label: 'Category'),
                  SizedBox(height: 4.h),
                  _CategoryDropdown(
                    categories: categories,
                    value: _categoryId,
                    onChanged: (value) async {
                      setState(() {
                        _categoryId = value;
                        _syncAttributes(const []);
                      });
                      if (value != null) {
                        await cubit.loadAttributes(
                          itemIndex: 0,
                          categoryId: value,
                        );
                      } else {
                        cubit.clearItemAttributes(0);
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  const _FieldLabel(label: 'Warranty INFO'),
                  SizedBox(height: 4.h),
                  _AuctionTextField(controller: _warrantyController),
                  SizedBox(height: 10.h),
                  const _SectionLabel(label: 'Description'),
                  SizedBox(height: 6.h),
                  _AuctionTextField(
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 4,
                  ),
                  if (attributes.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    const _SectionLabel(label: 'Attributes'),
                    SizedBox(height: 6.h),
                    ...attributes.map(
                      (attribute) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _AttributeField(
                          attribute: attribute,
                          controller: _attributeControllers.putIfAbsent(
                            attribute.id,
                            () => TextEditingController(),
                          ),
                          booleanValue: _booleanAttributes[attribute.id],
                          dateValue: _dateTimeAttributes[attribute.id],
                          onBooleanChanged: (value) {
                            setState(() {
                              _booleanAttributes[attribute.id] = value;
                            });
                          },
                          onPickDate: () => _pickDateValue(attribute),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                  const _SectionLabel(label: 'Condition'),
                  SizedBox(height: 4.h),
                  _ConditionRow(
                    selected: _selectedCondition,
                    onChanged: (value) {
                      setState(() => _selectedCondition = value);
                    },
                  ),
                  SizedBox(height: 18.h),
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
  const _UploadBox({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 92.h,
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
    required this.controller,
    required this.booleanValue,
    required this.dateValue,
    required this.onBooleanChanged,
    required this.onPickDate,
  });

  final CategoryAttributeModel attribute;
  final TextEditingController controller;
  final bool? booleanValue;
  final String? dateValue;
  final ValueChanged<bool?> onBooleanChanged;
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
                value: booleanValue,
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
                onChanged: onBooleanChanged,
              ),
            ),
          ),
        ],
      );
    }

    if (attribute.isDate || attribute.isDateTime) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: attribute.isRequired ? '$label *' : label),
          SizedBox(height: 4.h),
          _UploadBox(
            label: dateValue?.isNotEmpty == true
                ? dateValue!
                : attribute.isDateTime
                ? 'Select date & time'
                : 'Select date',
            onTap: onPickDate,
          ),
        ],
      );
    }

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
