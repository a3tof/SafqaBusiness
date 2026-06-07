import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';

class AuctionDetailModel {
  final int id;
  final String title;
  final String description;
  final String? image;
  final double startingPrice;
  final int bidIncrement;
  final DateTime? startDate;
  final DateTime? endDate;
  final int categoryId;
  final List<AuctionDetailItemModel> items;

  const AuctionDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.startingPrice,
    required this.bidIncrement,
    required this.startDate,
    required this.endDate,
    required this.categoryId,
    required this.items,
  });

  factory AuctionDetailModel.fromJson(Map<String, dynamic> json) {
    final itemsRaw = _asList(json['items'] ?? json['Items']);
    return AuctionDetailModel(
      id: _asInt(json['id'] ?? json['Id']) ?? 0,
      title: _asString(json['title'] ?? json['Title']) ?? '',
      description: _asString(json['description'] ?? json['Description']) ?? '',
      image: _asNullableString(json['image'] ?? json['Image']),
      startingPrice:
          _asDouble(json['startingPrice'] ?? json['StartingPrice']) ?? 0,
      bidIncrement: _asInt(json['bidIncrement'] ?? json['BidIncrement']) ?? 0,
      startDate: _asDateTime(json['startDate'] ?? json['StartDate']),
      endDate: _asDateTime(json['endDate'] ?? json['EndDate']),
      categoryId: _asInt(json['categoryId'] ?? json['CategoryId'] ?? json['category_id']) ?? 0,
      items: itemsRaw
          .whereType<Map>()
          .map(
            (item) => AuctionDetailItemModel.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
    );
  }
}

class AuctionDetailItemModel {
  final int id;
  final String title;
  final String description;
  final int count;
  final int condition;
  final String warrantyInfo;
  final int categoryId;
  final List<ItemAttributeValueModel> attributes;
  final List<String> images;

  const AuctionDetailItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.count,
    required this.condition,
    required this.warrantyInfo,
    required this.categoryId,
    required this.attributes,
    required this.images,
  });

  factory AuctionDetailItemModel.fromJson(Map<String, dynamic> json) {
    final attributesRaw = _asList(json['attributes'] ?? json['Attributes']);
    final imagesRaw = _asList(json['images'] ?? json['Images']);
    return AuctionDetailItemModel(
      id: _asInt(json['id'] ?? json['Id']) ?? 0,
      title: _asString(json['title'] ?? json['Title']) ?? '',
      description: _asString(json['description'] ?? json['Description']) ?? '',
      count: _asInt(json['count'] ?? json['Count']) ?? 0,
      condition: _asInt(json['condition'] ?? json['Condition']) ?? 0,
      warrantyInfo:
          _asString(json['warrantyInfo'] ?? json['WarrantyInfo']) ?? '',
      categoryId: _asInt(json['categoryId'] ?? json['CategoryId'] ?? json['category_id']) ?? 0,
      attributes: attributesRaw
          .whereType<Map>()
          .map(
            (attribute) => ItemAttributeValueModel.fromJson(
              attribute.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList(),
      images: imagesRaw
          .map((image) => image?.toString().trim() ?? '')
          .where((image) => image.isNotEmpty)
          .toList(),
    );
  }
}

class EditAuctionRequestModel {
  final String title;
  final String description;
  final XFile? image;
  final List<EditAuctionItemRequestModel> items;

  const EditAuctionRequestModel({
    required this.title,
    required this.description,
    required this.image,
    required this.items,
  });
}

class EditAuctionItemRequestModel {
  final int id;
  final String title;
  final int count;
  final String description;
  final String warrantyInfo;
  final int condition;
  final int categoryId;
  final List<XFile> images;
  final List<ItemAttributeValueModel> attributes;

  const EditAuctionItemRequestModel({
    required this.id,
    required this.title,
    required this.count,
    required this.description,
    required this.warrantyInfo,
    required this.condition,
    required this.categoryId,
    required this.images,
    required this.attributes,
  });
}

dynamic _decodeIfNeeded(dynamic data) {
  if (data is String) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }
  return data;
}

List<dynamic> _asList(dynamic data) {
  final decoded = _decodeIfNeeded(data);
  return decoded is List ? decoded : const [];
}

String? _asNullableString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }
  return text;
}

String? _asString(dynamic value) => _asNullableString(value);

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double? _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

DateTime? _asDateTime(dynamic value) {
  final raw = value?.toString();
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}
