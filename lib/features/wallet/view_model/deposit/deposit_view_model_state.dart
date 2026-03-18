abstract class DepositState {}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class DepositSuccess extends DepositState {}

class DepositError extends DepositState {
  final String message;
  DepositError(this.message);
}
