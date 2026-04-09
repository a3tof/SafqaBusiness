import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/subscription/model/repositories/subscription_repository.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model_state.dart';

class SubscriptionViewModel extends Cubit<SubscriptionState> {
  SubscriptionViewModel(this.subscriptionRepository)
    : super(
        SubscriptionInitial(
          activePlanId: subscriptionRepository.getActivePlanId(),
        ),
      );

  final SubscriptionRepository subscriptionRepository;

  Future<void> loadActivePlan({bool showLoading = false}) async {
    final activePlanId = subscriptionRepository.getActivePlanId();
    if (showLoading) {
      emit(SubscriptionScreenLoading(activePlanId: activePlanId));
      await Future<void>.delayed(const Duration(milliseconds: 900));
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    emit(
      SubscriptionInitial(
        activePlanId: subscriptionRepository.getActivePlanId(),
      ),
    );
  }

  Future<void> upgrade({required int upgradeType}) async {
    final planId = upgradeType.toString();
    emit(
      SubscriptionLoading(
        planId,
        activePlanId: subscriptionRepository.getActivePlanId(),
      ),
    );
    try {
      final savedPlanId = await _upgradeWithMinimumDelay(upgradeType);
      emit(SubscriptionSuccess(savedPlanId));
    } catch (e) {
      emit(
        SubscriptionError(
          _clean(e),
          planId,
          activePlanId: subscriptionRepository.getActivePlanId(),
        ),
      );
    }
  }

  Future<String> _upgradeWithMinimumDelay(int upgradeType) async {
    final result = await Future.wait<dynamic>([
      subscriptionRepository.upgrade(upgradeType: upgradeType),
      Future<void>.delayed(const Duration(milliseconds: 1200)),
    ]);
    return result.first as String;
  }

  String _clean(Object error) {
    var message = error.toString();
    if (message.startsWith('Exception: ')) {
      message = message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
