import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_action.dart';

import '../../redux/auth/auth_state.dart';

class ReferenceAccountMiddleware extends MiddlewareClass<AppState> {
  final PersonService _personService;

  ReferenceAccountMiddleware(this._personService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is GetReferenceAccountCommandAction) {
      final response = await _personService.getReferenceAccount(user: authState.authenticatedUser.cognito);

      if (response is GetReferenceAccountSuccessResponse) {
        store.dispatch(ReferenceAccountFetchedEventAction(response.referenceAccount));
      } else if (response is PersonServiceErrorResponse) {
        store.dispatch(GetReferenceAccountFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
