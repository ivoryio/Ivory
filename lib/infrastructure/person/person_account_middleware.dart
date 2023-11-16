import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_action.dart';

import '../../redux/auth/auth_state.dart';

class PersonAccountMiddleware extends MiddlewareClass<AppState> {
  final PersonService _personService;

  PersonAccountMiddleware(this._personService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is GetPersonAccountCommandAction) {
      final response = await _personService.getPersonAccount(user: authState.authenticatedUser.cognito);

      if (response is GetPersonAccountSuccessResponse) {
        store.dispatch(PersonAccountFetchedEventAction(response.personAccount));
      } else if (response is PersonServiceErrorResponse) {
        store.dispatch(GetPersonAccountFailedEventAction());
      }
    }
  }
}
