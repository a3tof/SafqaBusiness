import 'package:dio/dio.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

class WalletRepository {
  final DioHelper dioHelper;

  WalletRepository({required this.dioHelper});

  // ── Balance ───────────────────────────────────────────────────────────────

  Future<WalletBalance> getBalance() async {
    final r = await dioHelper.getData(
      endPoint: 'seller/Wallet',
      requiresAuth: true,
    );
    _require(r);
    return WalletBalance.fromJson(r.data as Map<String, dynamic>);
  }

  // ── Deposit ───────────────────────────────────────────────────────────────

  Future<void> deposit(DepositRequest request) async {
    final r = await dioHelper.postData(
      endPoint: 'seller/Wallet/Deposit',
      data: request.toJson(),
      requiresAuth: true,
    );
    _require(r);
  }

  // ── Withdrawal ────────────────────────────────────────────────────────────

  Future<void> withdraw(WithdrawalRequest request) async {
    final r = await dioHelper.postData(
      endPoint: 'seller/Wallet/Withdraw',
      data: request.toJson(),
      requiresAuth: true,
    );
    _require(r);
  }

  // ── Saved cards ───────────────────────────────────────────────────────────

  Future<List<CardModel>> getCards() async {
    final r = await dioHelper.getData(
      endPoint: 'seller/Wallet/Cards',
      requiresAuth: true,
    );
    _require(r);
    final list = r.data as List<dynamic>;
    return list
        .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCard(AddCardRequest request) async {
    final r = await dioHelper.postData(
      endPoint: 'seller/Wallet/Cards',
      data: request.toJson(),
      requiresAuth: true,
    );
    _require(r);
  }

  Future<void> deleteCard(int cardId) async {
    final r = await dioHelper.deleteData(
      endPoint: 'seller/Wallet/Cards/$cardId',
      requiresAuth: true,
    );
    _require(r);
  }

  // ── Transactions ──────────────────────────────────────────────────────────

  Future<List<TransactionModel>> getTransactions() async {
    final r = await dioHelper.getData(
      endPoint: 'seller/Wallet/Transactions',
      requiresAuth: true,
    );
    _require(r);
    final list = r.data as List<dynamic>;
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
}
