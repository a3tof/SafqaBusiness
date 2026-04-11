import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/core/widgets/location_picker_field.dart';
import 'package:safqaseller/features/auth/model/models/location_model.dart';
import 'package:safqaseller/features/auth/model/repositories/auth_repository.dart';
import 'package:safqaseller/features/profile/model/models/edit_profile_request.dart';
import 'package:safqaseller/features/profile/view_model/edit_account/edit_account_view_model.dart';
import 'package:safqaseller/features/profile/view_model/edit_account/edit_account_view_model_state.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditAccountViewBody extends StatefulWidget {
  const EditAccountViewBody({super.key, this.profile});

  final ProfileLoaded? profile;

  @override
  State<EditAccountViewBody> createState() => _EditAccountViewBodyState();
}

class _EditAccountViewBodyState extends State<EditAccountViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  List<LocationModel> _countries = [];
  List<LocationModel> _cities = [];
  LocationModel? _selectedCountry;
  LocationModel? _selectedCity;
  Uint8List? _selectedLogoBytes;
  String? _encodedLogo;
  bool _isLoadingLocations = false;
  String? _lastAppliedProfileKey;

  @override
  void initState() {
    super.initState();
    final currentProfileState = getIt<ProfileViewModel>().state;
    if (currentProfileState is ProfileLoaded) {
      _applyProfileData(currentProfileState, rebuild: false);
    } else {
      _applyProfileData(widget.profile, rebuild: false);
    }
    _loadCountries();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileViewModel>().fetchProfile(showLoadingState: true);
    });
  }

  void _applyProfileData(ProfileLoaded? profile, {bool rebuild = true}) {
    if (profile == null) return;

    final profileKey = [
      profile.fullName,
      profile.phoneNumber,
      profile.description,
      profile.countryId,
      profile.countryName,
      profile.cityId,
      profile.cityName,
      profile.logoBytes?.lengthInBytes,
    ].join('|');

    if (profileKey == _lastAppliedProfileKey) {
      return;
    }

    void assignValues() {
      _storeNameController.text = profile.fullName ?? '';
      _phoneNumberController.text = profile.phoneNumber ?? '';
      _descriptionController.text = profile.description ?? '';
      _selectedLogoBytes = profile.logoBytes;
      _encodedLogo = null;
      _selectedCountry =
          profile.countryId != null &&
              (profile.countryName?.isNotEmpty ?? false)
          ? LocationModel(id: profile.countryId!, name: profile.countryName!)
          : null;
      _selectedCity =
          profile.cityId != null && (profile.cityName?.isNotEmpty ?? false)
          ? LocationModel(id: profile.cityId!, name: profile.cityName!)
          : null;
      _lastAppliedProfileKey = profileKey;
    }

    if (rebuild && mounted) {
      setState(assignValues);
    } else {
      assignValues();
    }

    if (profile.countryId != null && _countries.isNotEmpty) {
      _loadCities(profile.countryId!, keepSelection: true);
    }
  }

  Future<void> _refreshProfile() async {
    await context.read<ProfileViewModel>().fetchProfile();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingLocations = true);
    try {
      _countries = await getIt<AuthRepository>().getCountries();
      if (_selectedCountry != null) {
        await _loadCities(_selectedCountry!.id, keepSelection: true);
      }
    } catch (_) {
      // Keep the form usable even if locations fail to load.
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocations = false);
      }
    }
  }

  Future<void> _loadCities(int countryId, {bool keepSelection = false}) async {
    setState(() => _isLoadingLocations = true);
    try {
      final cities = await getIt<AuthRepository>().getCities(countryId);
      if (!mounted) return;
      setState(() {
        _cities = cities;
        if (!keepSelection) {
          _selectedCity = null;
        } else if (_selectedCity != null) {
          final match = cities.where((city) => city.id == _selectedCity!.id);
          _selectedCity = match.isNotEmpty ? match.first : _selectedCity;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cities = [];
        if (!keepSelection) {
          _selectedCity = null;
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocations = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedLogoBytes = bytes;
      _encodedLogo = base64Encode(bytes);
    });
  }

  Future<void> _openLocationSheet() async {
    if (_countries.isEmpty && !_isLoadingLocations) {
      await _loadCountries();
    }
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    LocationModel? localCountry = _selectedCountry;
    LocationModel? localCity = _selectedCity;
    List<LocationModel> localCities = List<LocationModel>.from(_cities);
    bool isLoadingCities = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> loadCitiesForCountry(int countryId) async {
              setSheetState(() {
                isLoadingCities = true;
                localCity = null;
                localCities = [];
              });
              try {
                localCities = await getIt<AuthRepository>().getCities(
                  countryId,
                );
              } catch (_) {
                localCities = [];
              } finally {
                if (sheetContext.mounted) {
                  setSheetState(() => isLoadingCities = false);
                }
              }
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                24.h,
                20.w,
                MediaQuery.of(sheetContext).viewInsets.bottom + 24.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      S.of(context).kCity,
                      style: TextStyles.bold18(
                        context,
                      ).copyWith(color: AppColors.primaryColor),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      S.of(context).kCountry,
                      style: TextStyles.semiBold14(context),
                    ),
                    SizedBox(height: 8.h),
                    LocationPickerField(
                      enabled: _countries.isNotEmpty,
                      hintText: S.of(context).kSelectCountry,
                      locations: _countries,
                      selectedLocation: localCountry,
                      onChanged: (location) async {
                        setSheetState(() {
                          localCountry = location;
                        });
                        if (location != null) {
                          await loadCitiesForCountry(location.id);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      S.of(context).kCity,
                      style: TextStyles.semiBold14(context),
                    ),
                    SizedBox(height: 8.h),
                    if (isLoadingCities)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    else
                      LocationPickerField(
                        enabled: localCities.isNotEmpty,
                        hintText: S.of(context).kSelectCity,
                        locations: localCities,
                        selectedLocation: localCity,
                        onChanged: (location) {
                          setSheetState(() => localCity = location);
                        },
                      ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      height: 44.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          if (localCountry == null || localCity == null) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).kPleaseSelectACoun),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _selectedCountry = localCountry;
                            _selectedCity = localCity;
                            _cities = List<LocationModel>.from(localCities);
                          });
                          Navigator.pop(sheetContext);
                        },
                        child: Text(S.of(context).kSave),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).kPleaseSelectACoun)));
      return;
    }

    final request = EditProfileRequest(
      storeName: _storeNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      cityId: _selectedCity!.id,
      description: _descriptionController.text.trim(),
      storeLogo: _encodedLogo,
    );

    await context.read<EditAccountViewModel>().submit(request);
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _phoneNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileViewModel>().state;
    final isProfileLoading = profileState is ProfileInitial;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: S.of(context).kEditAccount),
      body: BlocListener<ProfileViewModel, ProfileViewModelState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _applyProfileData(state);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocConsumer<EditAccountViewModel, EditAccountState>(
          listener: (context, state) {
            if (state is EditAccountFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is EditAccountSuccess) {
              getIt<ProfileViewModel>().fetchProfile();
              Navigator.pop(context, S.of(context).kProfileUpdatedSuccessfully);
            }
          },
          builder: (context, state) {
            final isSubmitting = state is EditAccountLoading;

            return SafeArea(
              child: Skeletonizer(
                enabled: isProfileLoading,
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: _refreshProfile,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (profileState is ProfileError) ...[
                            Text(
                              profileState.message,
                              style: TextStyles.regular13(
                                context,
                              ).copyWith(color: Colors.red),
                            ),
                            SizedBox(height: 16.h),
                          ],
                          Center(
                            child: Column(
                              children: [
                                _EditableAvatar(
                                  imageBytes: _selectedLogoBytes,
                                  onTap: isProfileLoading ? null : _pickImage,
                                  tooltip: S.of(context).kEditAccountPhotoHint,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  S.of(context).kEditAccountPhotoHint,
                                  style: TextStyles.regular13(
                                    context,
                                  ).copyWith(color: const Color(0xFF7C7C7C)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          _EditFieldRow(
                            icon: Icons.person_outline,
                            controller: _storeNameController,
                            hintText: S.of(context).kStoreName,
                            enabled: !isProfileLoading && !isSubmitting,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 18.h),
                          _EditFieldRow(
                            icon: Icons.phone_outlined,
                            controller: _phoneNumberController,
                            hintText: S.of(context).kPhoneNumber,
                            enabled: !isProfileLoading && !isSubmitting,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 18.h),
                          _PickerFieldRow(
                            icon: Icons.location_on_outlined,
                            value:
                                _selectedCity?.name ??
                                _selectedCountry?.name ??
                                S.of(context).kSelectCity,
                            isPlaceholder:
                                _selectedCity == null &&
                                _selectedCountry == null,
                            onTap: isProfileLoading || _isLoadingLocations
                                ? null
                                : _openLocationSheet,
                          ),
                          SizedBox(height: 26.h),
                          Text(
                            S.of(context).kDescription,
                            style: TextStyles.semiBold16(
                              context,
                            ).copyWith(color: AppColors.primaryColor),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: const Color(0xFFB3B3B3),
                              ),
                            ),
                            child: TextFormField(
                              controller: _descriptionController,
                              enabled: !isProfileLoading && !isSubmitting,
                              maxLength: 50,
                              minLines: 4,
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return S.of(context).fieldRequired;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                counterStyle: TextStyles.regular12(
                                  context,
                                ).copyWith(color: const Color(0xFF7C7C7C)),
                              ),
                            ),
                          ),
                          SizedBox(height: 26.h),
                          SizedBox(
                            width: double.infinity,
                            height: 40.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: isSubmitting || isProfileLoading
                                  ? null
                                  : _submit,
                              child: isSubmitting
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      S.of(context).kSave,
                                      style: TextStyles.semiBold16(
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
            );
          },
        ),
      ),
    );
  }
}

class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({
    required this.imageBytes,
    required this.onTap,
    required this.tooltip,
  });

  final Uint8List? imageBytes;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 128.w,
            height: 128.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5F5F5),
              border: Border.all(color: const Color(0xFFE3E3E3)),
            ),
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(imageBytes!, fit: BoxFit.cover)
                  : Icon(
                      Icons.store_rounded,
                      size: 56.sp,
                      color: AppColors.primaryColor,
                    ),
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 2.h,
          end: 4.w,
          child: Tooltip(
            message: tooltip,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditFieldRow extends StatelessWidget {
  const _EditFieldRow({
    required this.icon,
    required this.controller,
    required this.hintText,
    required this.enabled,
    this.keyboardType,
    this.validator,
  });

  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 22.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                keyboardType: keyboardType,
                validator: validator,
                style: TextStyles.semiBold16(context),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyles.semiBold16(
                    context,
                  ).copyWith(color: const Color(0xFF939393)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  errorStyle: TextStyles.regular12(
                    context,
                  ).copyWith(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
        Divider(color: const Color(0xFFD9D9D9), height: 1.h),
      ],
    );
  }
}

class _PickerFieldRow extends StatelessWidget {
  const _PickerFieldRow({
    required this.icon,
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final IconData icon;
  final String value;
  final VoidCallback? onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 22.sp),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  value,
                  style: TextStyles.semiBold16(context).copyWith(
                    color: isPlaceholder
                        ? const Color(0xFF939393)
                        : AppColors.primaryColor,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF939393),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: const Color(0xFFD9D9D9), height: 1.h),
        ],
      ),
    );
  }
}
