import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {
  final WalletBalance balance;
  final List<CardModel> cards;
  final List<TransactionModel> transactions;

  WalletSuccess({
    required this.balance,
    required this.cards,
    required this.transactions,
  });
}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}
