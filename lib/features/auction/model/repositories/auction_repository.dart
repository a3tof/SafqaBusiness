import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';

class AuctionRepository {
  final DioHelper dioHelper;

  AuctionRepository({required this.dioHelper});

  Future<List<CategoryModel>> getCategories() async {
    final response = await dioHelper.getData(
      endPoint: 'Auction/Get-Categories',
      requiresAuth: true,
    );
    _requireSuccess(response);

    final data = _asList(response.data);
    return data
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryAttributeModel>> getAttributes(int categoryId) async {
    final response = await dioHelper.getData(
      endPoint: 'Auction/Get-Attributes/$categoryId',
      requiresAuth: true,
    );
    _requireSuccess(response);

    final data = _asList(response.data);
    return data
        .map(
          (item) =>
              CategoryAttributeModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> createAuction({
    required String title,
    required String description,
    required double startingPrice,
    required int bidIncrement,
    required int durationInDays,
    required List<AuctionItemModel> items,
    XFile? headImage,
  }) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('Title', title),
      MapEntry('Description', description),
      MapEntry('StartingPrice', _numberToString(startingPrice)),
      MapEntry('BidIncrement', bidIncrement.toString()),
      MapEntry('DurationInDays', durationInDays.toString()),
    ]);

    if (headImage != null) {
      formData.files.add(
        MapEntry(
          'HeadImage',
          await MultipartFile.fromFile(
            headImage.path,
            filename: headImage.name,
          ),
        ),
      );
    }

    for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
      final item = items[itemIndex];
      formData.fields.addAll([
        MapEntry('Items[$itemIndex].Title', item.title),
        MapEntry('Items[$itemIndex].count', item.count.toString()),
        MapEntry('Items[$itemIndex].description', item.description),
        MapEntry('Items[$itemIndex].warrantyInfo', item.warrantyInfo),
        MapEntry('Items[$itemIndex].condition', item.condition.toString()),
        MapEntry('Items[$itemIndex].categoryId', item.categoryId.toString()),
      ]);

      for (var imageIndex = 0; imageIndex < item.images.length; imageIndex++) {
        final image = item.images[imageIndex];
        formData.files.add(
          MapEntry(
            'Items[$itemIndex].images',
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }

      for (
        var attributeIndex = 0;
        attributeIndex < item.attributes.length;
        attributeIndex++
      ) {
        final attribute = item.attributes[attributeIndex];
        formData.fields.addAll([
          MapEntry(
            'Items[$itemIndex].attributes[$attributeIndex].categoryAttributeId',
            attribute.categoryAttributeId.toString(),
          ),
          MapEntry(
            'Items[$itemIndex].attributes[$attributeIndex].value',
            attribute.value,
          ),
        ]);
      }
    }

    final response = await dioHelper.postFormData(
      endPoint: 'Auction/Create-Auction',
      data: formData,
      requiresAuth: true,
    );
    _requireSuccess(response);

    final body = _asMap(response.data);
    final isSuccess = body['isSuccess'] ?? body['IsSuccess'] ?? false;
    if (isSuccess != true) {
      throw Exception(
        body['message'] ?? body['Message'] ?? 'Create auction failed',
      );
    }
  }

  void _requireSuccess(Response<dynamic> response) {
    final statusCode = response.statusCode;
    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw Exception(extractResponseError(response.data, statusCode));
    }
  }

  List<dynamic> _asList(dynamic data) {
    final decoded = _decodeIfNeeded(data);
    if (decoded is List<dynamic>) {
      return decoded;
    }
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    final decoded = _decodeIfNeeded(data);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
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

  String _numberToString(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
