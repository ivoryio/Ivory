import 'package:solarisdemo/redux/person/reference_account_action.dart';
import 'package:solarisdemo/redux/person/reference_account_state.dart';

ReferenceAccountState referenceAccountReducer(ReferenceAccountState currentState, dynamic action) {
  if (action is GetReferenceAccountCommandAction) {
    return ReferenceAccountLoadingState();
  } else if (action is GetReferenceAccountSuccessEventAction) {
    return ReferenceAccountFetchedState(action.referenceAccount);
  } else if (action is GetReferenceAccountFailedEventAction) {
    return ReferenceAccountErrorState();
  }

  return currentState;
}
