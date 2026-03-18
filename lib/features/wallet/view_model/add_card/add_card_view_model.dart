import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model_state.dart';

class AddCardViewModel extends Cubit<AddCardState> {
  final WalletRepository walletRepository;

  AddCardViewModel(this.walletRepository) : super(AddCardInitial());

  Future<void> addCard(AddCardRequest request) async {
    emit(AddCardLoading());
    try {
      await walletRepository.addCard(request);
      emit(AddCardSuccess());
    } catch (e) {
      String msg = e.toString();
      if (msg.startsWith('Exception: ')) msg = msg.replaceFirst('Exception: ', '');
      emit(AddCardError(msg));
    }
  }
}
