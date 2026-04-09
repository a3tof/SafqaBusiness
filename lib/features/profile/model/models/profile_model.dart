import 'dart:convert';
import 'dart:typed_data';

class ProfileModel {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final int? countryId;
  final String? countryName;
  final int? cityId;
  final String? cityName;
  final String? description;

  /// Raw base64-encoded image string returned by the API.
  final String? storeLogo;
  final String rating;
  final String followersCount;
  final String auctionsCount;

  ProfileModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.countryId,
    this.countryName,
    this.cityId,
    this.cityName,
    this.description,
    this.storeLogo,
    this.rating = '0',
    this.followersCount = '0',
    this.auctionsCount = '0',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName:
          (json['fullName'] ??
                  json['FullName'] ??
                  json['name'] ??
                  json['Name'] ??
                  json['storeName'] ??
                  json['StoreName'])
              as String?,
      email: (json['email'] ?? json['Email']) as String?,
      phoneNumber:
          (json['phoneNumber'] ??
                  json['PhoneNumber'] ??
                  json['phone'] ??
                  json['Phone'])
              as String?,
      countryId: _parseInt(
        json['countryId'] ?? json['CountryId'] ?? json['countryID'],
      ),
      countryName:
          (json['countryName'] ??
                  json['CountryName'] ??
                  json['country'] ??
                  json['Country'])
              as String?,
      cityId: _parseInt(json['cityId'] ?? json['CityId'] ?? json['cityID']),
      cityName:
          (json['cityName'] ?? json['CityName'] ?? json['city'] ?? json['City'])
              as String?,
      description: (json['description'] ?? json['Description']) as String?,
      storeLogo:
          (json['storeLogo'] ??
                  json['StoreLogo'] ??
                  json['logo'] ??
                  json['Logo'] ??
                  json['profileImage'] ??
                  json['ProfileImage'] ??
                  json['image'] ??
                  json['Image'])
              as String?,
      rating:
          _stringifyMetric(
            json['sellerRating'] ??
                json['SellerRating'] ??
                json['rating'] ??
                json['Rating'],
          ) ??
          '0',
      followersCount:
          _stringifyMetric(
            json['followers'] ??
                json['Followers'] ??
                json['followersCount'] ??
                json['FollowersCount'],
          ) ??
          '0',
      auctionsCount:
          _stringifyMetric(
            json['auctionsCount'] ??
                json['AuctionsCount'] ??
                json['auctionCount'] ??
                json['AuctionCount'] ??
                json['totalAuctions'] ??
                json['TotalAuctions'],
          ) ??
          '0',
    );
  }

  /// Decodes the base64 logo into raw bytes for `Image.memory`.
  Uint8List? get logoBytes {
    if (storeLogo == null || storeLogo!.isEmpty) return null;
    try {
      return base64Decode(storeLogo!);
    } catch (_) {
      return null;
    }
  }
}

String? _stringifyMetric(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
  return value.toString();
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}
