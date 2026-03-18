import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view_model/deposit/deposit_view_model_state.dart';

class DepositViewModel extends Cubit<DepositState> {
  final WalletRepository walletRepository;

  DepositViewModel(this.walletRepository) : super(DepositInitial());

  Future<void> deposit(double amount) async {
    emit(DepositLoading());
    try {
      await walletRepository.deposit(DepositRequest(amount: amount));
      emit(DepositSuccess());
    } catch (e) {
      String msg = e.toString();
      if (msg.startsWith('Exception: ')) msg = msg.replaceFirst('Exception: ', '');
      emit(DepositError(msg));
    }
  }
}
