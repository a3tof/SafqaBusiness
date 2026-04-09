import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/profile/model/models/edit_profile_request.dart';
import 'package:safqaseller/features/profile/model/repositories/profile_repository.dart';
import 'package:safqaseller/features/profile/view_model/edit_account/edit_account_view_model_state.dart';

class EditAccountViewModel extends Cubit<EditAccountState> {
  final ProfileRepository _repository;

  EditAccountViewModel(this._repository) : super(EditAccountInitial());

  Future<void> submit(EditProfileRequest request) async {
    emit(EditAccountLoading());
    try {
      await _repository.editProfile(request);
      emit(EditAccountSuccess());
    } catch (error) {
      emit(EditAccountFailure(_cleanError(error)));
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
