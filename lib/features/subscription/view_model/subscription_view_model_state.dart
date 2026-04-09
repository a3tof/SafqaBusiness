abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {
  SubscriptionLoading(this.planId);

  final String planId;
}

class SubscriptionSuccess extends SubscriptionState {
  SubscriptionSuccess(this.planId);

  final String planId;
}

class SubscriptionError extends SubscriptionState {
  SubscriptionError(this.message, this.planId);

  final String message;
  final String planId;
}
