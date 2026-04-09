class EditProfileRequest {
  final String storeName;
  final String phoneNumber;
  final int cityId;
  final String description;
  final String? storeLogo;

  const EditProfileRequest({
    required this.storeName,
    required this.phoneNumber,
    required this.cityId,
    required this.description,
    this.storeLogo,
  });

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'phoneNumber': phoneNumber,
      'cityId': cityId,
      'description': description,
      if (storeLogo != null) 'storeLogo': storeLogo,
    };
  }
}
