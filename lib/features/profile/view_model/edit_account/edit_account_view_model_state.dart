import 'package:equatable/equatable.dart';

abstract class EditAccountState extends Equatable {
  const EditAccountState();

  @override
  List<Object?> get props => [];
}

class EditAccountInitial extends EditAccountState {}

class EditAccountLoading extends EditAccountState {}

class EditAccountSuccess extends EditAccountState {}

class EditAccountFailure extends EditAccountState {
  final String message;

  const EditAccountFailure(this.message);

  @override
  List<Object?> get props => [message];
}
