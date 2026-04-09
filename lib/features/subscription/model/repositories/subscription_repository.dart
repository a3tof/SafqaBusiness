import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';

class SubscriptionRepository {
  SubscriptionRepository({required this.dioHelper, required this.cacheHelper});

  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

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
