import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/auction/model/models/auction_detail_model.dart';
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
    required DateTime startDate,
    required DateTime endDate,
    required List<AuctionItemModel> items,
    XFile? headImage,
  }) async {
    final formData = FormData();
    final rootCategoryId = items.isNotEmpty ? items.first.categoryId : null;
    final queryParams = <String, dynamic>{
      'Title': title,
      'Description': description,
      'StartingPrice': startingPrice,
      'BidIncrement': bidIncrement,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      ...?rootCategoryId == null ? null : {'categoryId': rootCategoryId},
    };

    formData.fields.addAll([
      MapEntry('Title', title),
      MapEntry('Description', description),
      MapEntry('StartingPrice', _numberToString(startingPrice)),
      MapEntry('BidIncrement', bidIncrement.toString()),
      MapEntry('StartDate', startDate.toIso8601String()),
      MapEntry('EndDate', endDate.toIso8601String()),
      if (rootCategoryId != null)
        MapEntry('categoryId', rootCategoryId.toString()),
    ]);

    if (headImage != null) {
      formData.files.add(
        MapEntry(
          'Image',
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
      queryParams: queryParams,
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

  Future<AuctionDetailModel> viewAuction(int id) async {
    final response = await dioHelper.getData(
      endPoint: 'Auction/View/$id',
      requiresAuth: true,
    );
    _requireSuccess(response);

    final envelope = _asMap(response.data);

    // DEBUG: log raw keys so we can see the actual field names from the server
    if (kDebugMode) {
      debugPrint('🔍 View[$id] envelope keys: ${envelope.keys.toList()}');
      debugPrint('🔍 View[$id] raw: ${response.data}');
    }

    // The server may wrap the payload in an envelope:
    //   { "isSuccess": true, "data": { "id": ..., ... } }
    // Unwrap it so fromJson sees the real auction fields.
    final data =
        _asMapOrNull(envelope['data'] ?? envelope['Data']) ??
        _asMapOrNull(envelope['result'] ?? envelope['Result']) ??
        _asMapOrNull(envelope['auction'] ?? envelope['Auction']) ??
        (envelope.containsKey('id') || envelope.containsKey('Id')
            ? envelope
            : null) ??
        envelope;

    if (kDebugMode) {
      debugPrint('🔍 View[$id] parsed id: ${data['id'] ?? data['Id']}');
    }

    return AuctionDetailModel.fromJson(data);
  }

  Future<void> editAuction({
    required int id,
    required EditAuctionRequestModel request,
  }) async {
    final formData = FormData();
    final rootCategoryId = request.items.isNotEmpty
        ? request.items.first.categoryId
        : null;

    formData.fields.addAll([
      MapEntry('title', request.title),
      MapEntry('Description', request.description),
      if (rootCategoryId != null && rootCategoryId > 0)
        MapEntry('categoryId', rootCategoryId.toString()),
    ]);

    if (request.image != null) {
      formData.files.add(
        MapEntry(
          'Image',
          await MultipartFile.fromFile(
            request.image!.path,
            filename: request.image!.name,
          ),
        ),
      );
    }

    for (var itemIndex = 0; itemIndex < request.items.length; itemIndex++) {
      final item = request.items[itemIndex];
      formData.fields.addAll([
        MapEntry('Items[$itemIndex].id', item.id.toString()),
        MapEntry('Items[$itemIndex].title', item.title),
        MapEntry('Items[$itemIndex].count', item.count.toString()),
        MapEntry('Items[$itemIndex].description', item.description),
        MapEntry('Items[$itemIndex].warrantyInfo', item.warrantyInfo),
        MapEntry('Items[$itemIndex].condition', item.condition.toString()),
        MapEntry('Items[$itemIndex].categoryId', item.categoryId.toString()),
      ]);

      for (final image in item.images) {
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

    final response = await dioHelper.putFormData(
      endPoint: 'Auction/edit/$id',
      data: formData,
      requiresAuth: true,
    );
    _requireSuccess(response);
    _requireBackendSuccess(
      response.data,
      fallbackMessage: 'Update auction failed',
    );
  }

  Future<void> deleteAuction(int id) async {
    final response = await dioHelper.deleteData(
      endPoint: 'Auction/Delete/$id',
      requiresAuth: true,
    );
    _requireSuccess(response);
    _requireBackendSuccess(
      response.data,
      fallbackMessage: 'Delete auction failed',
    );
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

  Map<String, dynamic>? _asMapOrNull(dynamic data) {
    if (data == null) return null;
    final decoded = _decodeIfNeeded(data);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  void _requireBackendSuccess(dynamic data, {required String fallbackMessage}) {
    final body = _asMap(data);
    if (body.isEmpty) {
      return;
    }

    final isSuccess = body['isSuccess'] ?? body['IsSuccess'];
    if (isSuccess == false) {
      throw Exception(body['message'] ?? body['Message'] ?? fallbackMessage);
    }
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
