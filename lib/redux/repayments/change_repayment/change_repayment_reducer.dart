import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';

ChangeRepaymentState changeRepaymentReducer(ChangeRepaymentState currentState, dynamic action) {
  if (action is ChangeRepaymentLoadingAction) {
    return ChangeRepaymentLoadingState();
  } else if (action is ChangeRepaymentFailedAction) {
    return ChangeRepaymentErrorState();
  } else if (action is UpdateChangeRepaymentCommandAction) {
    return ChangeRepaymentUpdateState(action.fixedRate);
  } else if (action is UpdateChangeRepaymentEventAction) {
    return ChangeRepaymentUpdateState(action.fixedRate);
  }

  return currentState;
}
