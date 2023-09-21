import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';

class ChangeRepaymentMiddleware extends MiddlewareClass<AppState> {
  final ChangeRepaymentService _changeRepaymentService;

  ChangeRepaymentMiddleware(this._changeRepaymentService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is UpdateChangeRepaymentCommandAction) {
      store.dispatch(ChangeRepaymentLoadingAction());

      final response = await _changeRepaymentService.updateChangeRepayment(
        user: action.user.cognito,
        fixedRate: action.fixedRate,
      );

      if (response is ChangeRepaymentSuccessResponse) {
        store.dispatch(UpdateChangeRepaymentEventAction(fixedRate: response.fixedRate));
      } else {
        store.dispatch(ChangeRepaymentFailedAction());
      }
    }
  }
}
