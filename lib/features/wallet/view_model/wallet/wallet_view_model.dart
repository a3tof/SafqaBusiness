import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model_state.dart';

class WalletViewModel extends Cubit<WalletState> {
  final WalletRepository walletRepository;

  WalletViewModel(this.walletRepository) : super(WalletInitial());

  Future<void> loadWallet() async {
    emit(WalletLoading());
    try {
      final balance = await walletRepository.getBalance();
      final cards = await walletRepository.getCards();
      final transactions = await walletRepository.getTransactions();
      emit(WalletSuccess(
        balance: balance,
        cards: cards,
        transactions: transactions,
      ));
    } catch (e) {
      emit(WalletError(_clean(e)));
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {
      await walletRepository.deleteCard(cardId);
      await loadWallet();
    } catch (e) {
      emit(WalletError(_clean(e)));
    }
  }

  String _clean(Object e) {
    String msg = e.toString();
    if (msg.startsWith('Exception: ')) msg = msg.replaceFirst('Exception: ', '');
    return msg;
  }
}
