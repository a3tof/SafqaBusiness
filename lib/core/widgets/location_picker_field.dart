import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/model/models/location_model.dart';

class LocationPickerField extends StatefulWidget {
  const LocationPickerField({
    super.key,
    required this.hintText,
    required this.locations,
    this.selectedLocation,
    this.onSaved,
    this.onChanged,
    this.enabled = true,
  });

  final String hintText;
  final List<LocationModel> locations;
  final LocationModel? selectedLocation;
  final void Function(LocationModel?)? onSaved;
  final void Function(LocationModel?)? onChanged;
  final bool enabled;

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  LocationModel? selectedLocation;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
    if (selectedLocation != null) {
      controller.text = selectedLocation!.name;
    }
  }

  @override
  void didUpdateWidget(LocationPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLocation != widget.selectedLocation) {
      selectedLocation = widget.selectedLocation;
      controller.text = selectedLocation?.name ?? '';
    }
  }

  void _showLocationPicker(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 0),
              child: Column(
                children: [
                  Container(
                    width: 40.sp,
                    height: 4.sp,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  Text(
                    widget.hintText,
                    style: TextStyles.bold18(context),
                  ),
                  SizedBox(height: 10.sp),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: widget.locations.length,
                      separatorBuilder: (context, index) => Divider(height: 1.sp),
                      itemBuilder: (context, index) {
                        final location = widget.locations[index];
                        return ListTile(
                          title: Text(
                            location.name,
                            style: TextStyles.semiBold16(context),
                          ),
                          trailing: selectedLocation?.id == location.id
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                  size: 24.sp,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              selectedLocation = location;
                              controller.text = location.name;
                              if (widget.onChanged != null) {
                                widget.onChanged!(location);
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      readOnly: true,
      onTap: widget.enabled && widget.locations.isNotEmpty ? () => _showLocationPicker(context) : null,
      onSaved: (value) {
        if (widget.onSaved != null) {
          widget.onSaved!(selectedLocation);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: theme.hintColor,
          size: 24.sp,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyles.bold13(
          context,
        ).copyWith(color: theme.hintColor),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: buildBorder(theme),
        enabledBorder: buildBorder(theme),
        focusedBorder: buildBorder(theme),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: BorderSide(width: 1, color: theme.colorScheme.outline),
    );
  }
}
