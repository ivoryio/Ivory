import 'package:solarisdemo/redux/person/person_account/person_account_action.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';

PersonAccountState personAccountReducer(PersonAccountState state, dynamic action) {
  if (action is GetPersonAccountCommandAction) {
    return PersonAccountLoadingState();
  } else if (action is PersonAccountFetchedEventAction) {
    return PersonAccountFetchedState(action.personAccount);
  } else if (action is GetPersonAccountFailedEventAction) {
    return PersonAccountErrorState();
  }

  return state;
}
