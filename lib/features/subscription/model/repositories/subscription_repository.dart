import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';

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
      await cacheHelper.saveData(key: CacheKeys.activePlan, value: planId);
      final currentUserId = cacheHelper
          .getData(key: CacheKeys.userId)
          ?.toString();
      if (currentUserId != null && currentUserId.isNotEmpty) {
        await cacheHelper.saveData(
          key: CacheKeys.activePlanUserId,
          value: currentUserId,
        );
      }
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
}
