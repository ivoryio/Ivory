import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_action.dart';

import '../../../redux/app_state.dart';
import '../../../redux/auth/auth_state.dart';

class GetMoreCreditMiddleware extends MiddlewareClass<AppState> {
  final MoreCreditService moreCreditService;

  GetMoreCreditMiddleware(this.moreCreditService);

  @override
  Future<void> call(
      Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is GetMoreCreditCommandAction) {
      store.dispatch(MoreCreditLoadingEventAction());
      final response = await moreCreditService.getWaitlistStatus(
        user: authState.authenticatedUser.cognito,
      );

      if (response is GetMoreCreditSuccessResponse) {
        store.dispatch(MoreCreditFetchedEventAction(
          waitlist: response.waitlist,
        ));
      } else {
        store.dispatch(MoreCreditFailedEventAction());
      }
    }

    if (action is UpdateMoreCreditCommandAction) {
      store.dispatch(MoreCreditLoadingEventAction());
      final response = await moreCreditService.changeWaitlistStatus(
        user: authState.authenticatedUser.cognito,
      );

      if (response is GetMoreCreditSuccessResponse) {
        store.dispatch(MoreCreditFetchedEventAction(
          waitlist: response.waitlist,
        ));
      } else {
        store.dispatch(MoreCreditFailedEventAction());
      }
    }
  }
}
