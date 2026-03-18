abstract class WithdrawalState {}

class WithdrawalInitial extends WithdrawalState {}

class WithdrawalLoading extends WithdrawalState {}

class WithdrawalSuccess extends WithdrawalState {}

class WithdrawalError extends WithdrawalState {
  final String message;
  WithdrawalError(this.message);
}
