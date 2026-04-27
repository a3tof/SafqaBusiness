import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/history/model/models/history_models.dart';

class HistoryRepository {
  final DioHelper dioHelper;

  HistoryRepository({required this.dioHelper});

  Future<HistoryPage> getHistory({
    int page = 1,
    int pageSize = 10,
    AuctionStatus? status,
  }) async {
    final response = await dioHelper.getData(
      endPoint: 'Auction/Get-History',
      requiresAuth: true,
      queryParams: {
        'page': page,
        'pageSize': pageSize,
        if (status != null) 'status': status.index + 1,
      },
    );

    // 403 = seller profile not yet complete; return empty page silently.
    if (response.statusCode == 403) {
      return HistoryPage(items: [], totalCount: 0, page: page, pageSize: pageSize);
    }

    _require(response);

    // ── TEMP DEBUG: print raw response to see actual field names ─────────────
    debugPrint('📋 Get-History raw response: ${response.data}');
    // ────────────────────────────────────────────────────────────────────────

    return HistoryPage.fromJson(
      response.data,
      page: page,
      pageSize: pageSize,
    );
  }

  void _require(Response<dynamic> response) {
    final code = response.statusCode;
    if (code != null && (code < 200 || code > 299)) {
      throw Exception(extractResponseError(response.data, code));
    }
  }
}
