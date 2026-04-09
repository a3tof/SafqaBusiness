abstract class SubscriptionState {
  const SubscriptionState({required this.activePlanId});

  final String? activePlanId;
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial({required super.activePlanId});
}

class SubscriptionScreenLoading extends SubscriptionState {
  const SubscriptionScreenLoading({required super.activePlanId});
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading(this.planId, {required super.activePlanId});

  final String planId;
}

class SubscriptionSuccess extends SubscriptionState {
  const SubscriptionSuccess(this.planId) : super(activePlanId: planId);

  final String planId;
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError(
    this.message,
    this.planId, {
    required super.activePlanId,
  });

  final String message;
  final String planId;
}
