import 'package:dio/dio.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

class WalletRepository {
  final DioHelper dioHelper;

  WalletRepository({required this.dioHelper});

  // ── Balance ───────────────────────────────────────────────────────────────

  Future<WalletBalance> getBalance() async {
    final r = await dioHelper.getData(
      endPoint: 'Wallet/balance',
      requiresAuth: true,
    );
    // 403 = seller profile not yet complete; return zero balance silently.
    if (r.statusCode == 403) return const WalletBalance(balance: 0);
    _require(r);
    final body = _asMap(r.data);
    if (body != null) {
      return WalletBalance.fromJson(body);
    }
    if (r.data is num || r.data is String) {
      return WalletBalance.fromJson({'balance': r.data});
    }
    throw Exception('Unexpected wallet balance response format');
  }

  // ── Deposit ───────────────────────────────────────────────────────────────

  Future<void> deposit(DepositRequest request) async {
    var r = await dioHelper.postData(
      endPoint: 'Wallet/deposit',
      data: request.toJson(),
      requiresAuth: true,
    );
    if (_isWalletNotFound(r)) {
      await dioHelper.forceRefreshSession();
      r = await dioHelper.postData(
        endPoint: 'Wallet/deposit',
        data: request.toJson(),
        requiresAuth: true,
      );
    }
    _require(r);
  }

  // ── Withdrawal ────────────────────────────────────────────────────────────

  Future<void> withdraw(WithdrawalRequest request) async {
    var r = await dioHelper.postData(
      endPoint: 'Wallet/withdraw',
      data: request.toJson(),
      requiresAuth: true,
    );
    if (_isWalletNotFound(r)) {
      await dioHelper.forceRefreshSession();
      r = await dioHelper.postData(
        endPoint: 'Wallet/withdraw',
        data: request.toJson(),
        requiresAuth: true,
      );
    }
    _require(r);
  }

  // ── Saved cards ───────────────────────────────────────────────────────────

  Future<List<CardModel>> getCards() async {
    final r = await dioHelper.getData(
      endPoint: 'Card/cards',
      requiresAuth: true,
    );
    // 403 = seller profile not yet complete; return empty cards silently.
    if (r.statusCode == 403) return [];
    _require(r);
    final list = _asList(r.data);
    if (list == null) {
      throw Exception('Unexpected cards response format');
    }
    return list
        .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCard(AddCardRequest request) async {
    final r = await dioHelper.postData(
      endPoint: 'Card/AddCard',
      data: request.toJson(),
      requiresAuth: true,
    );
    _require(r);
  }

  Future<void> deleteCard(int cardId) async {
    final r = await dioHelper.deleteData(
      endPoint: 'Card/Delete-Card/$cardId',
      requiresAuth: true,
    );
    _require(r);
  }

  // ── Transactions ──────────────────────────────────────────────────────────

  Future<List<TransactionModel>> getTransactions() async {
    final r = await dioHelper.getData(
      endPoint: 'Wallet/TransactionHistory',
      requiresAuth: true,
    );
    if (_isNoTransactionsResponse(r)) {
      return [];
    }
    _require(r);
    final list = _asList(r.data);
    if (list == null) {
      throw Exception('Unexpected transaction history response format');
    }
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  void _require(Response<dynamic> r) {
    final code = r.statusCode;
    if (code != null && (code < 200 || code > 299)) {
      throw Exception(extractResponseError(r.data, code));
    }
  }

  bool _isWalletNotFound(Response<dynamic> r) {
    if (r.statusCode != 400) return false;
    final message = extractResponseError(r.data, r.statusCode).toLowerCase();
    return message.contains('wallet not found');
  }

  bool _isNoTransactionsResponse(Response<dynamic> r) {
    if (r.statusCode != 404) return false;
    final message = extractResponseError(r.data, r.statusCode).toLowerCase();
    return message.contains('no transactions');
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }
    return null;
  }

  List<dynamic>? _asList(dynamic data) {
    if (data is List) return data;
    final body = _asMap(data);
    if (body == null) return null;
    for (final key in const [
      'data',
      'Data',
      'items',
      'Items',
      'cards',
      'Cards',
      'transactions',
      'Transactions',
      'history',
      'History',
    ]) {
      final value = body[key];
      if (value is List) {
        return value;
      }
    }
    return null;
  }
}
