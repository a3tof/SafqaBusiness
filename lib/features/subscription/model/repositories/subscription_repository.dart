import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/profile/model/models/profile_model.dart';

class SubscriptionRepository {
  SubscriptionRepository({required this.dioHelper, required this.cacheHelper});

  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  String? getActivePlanId() {
    final currentUserId = cacheHelper
        .getData(key: CacheKeys.userId)
        ?.toString();
    final planUserId = cacheHelper
        .getData(key: CacheKeys.activePlanUserId)
        ?.toString();

    if (currentUserId == null ||
        currentUserId.isEmpty ||
        planUserId == null ||
        planUserId.isEmpty ||
        currentUserId != planUserId) {
      return null;
    }

    return cacheHelper.getData(key: CacheKeys.activePlan)?.toString();
  }

  Future<String?> refreshActivePlanId() async {
    final response = await dioHelper.getData(
      endPoint: 'seller/business-account',
      requiresAuth: true,
    );

    final code = response.statusCode;
    final body = _asMap(response.data);
    final isSuccessful = code != null && code >= 200 && code < 300;
    if (!isSuccessful) {
      throw Exception(extractResponseError(response.data, code));
    }

    final activePlanId = ProfileModel.fromJson(body).activePlanId;
    await _syncActivePlan(activePlanId);
    return activePlanId;
  }

  Future<String> upgrade({required int upgradeType}) async {
    final response = await dioHelper.postData(
      endPoint: 'seller/upgrade',
      data: {'upgradeType': upgradeType},
      requiresAuth: true,
    );

    final code = response.statusCode;
    final body = _asMap(response.data);
    final isSuccessful = code != null && code >= 200 && code < 300;

    if (isSuccessful && body['isSuccess'] == true) {
      final planId = upgradeType.toString();
      await _syncActivePlan(planId);
      return planId;
    }

    throw Exception(extractResponseError(response.data, code));
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  Future<void> _syncActivePlan(String? activePlanId) async {
    final currentUserId = cacheHelper
        .getData(key: CacheKeys.userId)
        ?.toString();

    if (activePlanId == null || activePlanId.isEmpty) {
      await cacheHelper.removeData(key: CacheKeys.activePlan);
      await cacheHelper.removeData(key: CacheKeys.activePlanUserId);
      return;
    }

    await cacheHelper.saveData(key: CacheKeys.activePlan, value: activePlanId);
    if (currentUserId != null && currentUserId.isNotEmpty) {
      await cacheHelper.saveData(
        key: CacheKeys.activePlanUserId,
        value: currentUserId,
      );
    }
  }
}
