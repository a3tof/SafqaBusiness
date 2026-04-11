import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/change_password/model/models/change_password_models.dart';

class ChangePasswordRepository {
  ChangePasswordRepository({required this.dioHelper});

  final DioHelper dioHelper;

  Future<void> changePassword(ChangePasswordRequest request) async {
    final response = await dioHelper.postData(
      endPoint: 'Auth/change-password',
      data: request.toJson(),
      requiresAuth: true,
    );

    final statusCode = response.statusCode;
    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw Exception(extractResponseError(response.data, statusCode));
    }

    final body = response.data;
    if (body is Map<String, dynamic> && body['isSuccess'] == true) {
      final storedToken = await dioHelper.storeSessionFromResponse(body);
      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Password changed successfully, but no new token was returned.');
      }
      return;
    }

    throw Exception(extractResponseError(body, statusCode));
  }
}
