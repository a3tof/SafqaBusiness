import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/home/view_model/home_view_model_state.dart';
import 'package:safqaseller/features/seller/model/repositories/seller_repository.dart';

class HomeViewModel extends Cubit<HomeViewModelState> {
  final SellerRepository _repository;

  HomeViewModel(this._repository) : super(HomeInitial());

  @override
  void emit(HomeViewModelState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  void reset() {
    emit(HomeInitial());
  }

  Future<void> loadHomeData({bool force = false}) async {
    if (!force && state is HomeSuccess) {
      return;
    }
    emit(HomeLoading());
    try {
      final data = await _repository.getSellerHome();
      emit(HomeSuccess(data));
    } catch (e) {
      emit(HomeFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
