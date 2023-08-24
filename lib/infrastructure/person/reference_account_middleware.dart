import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/person/reference_account_action.dart';

class ReferenceAccountMiddleware extends MiddlewareClass<AppState> {
  final PersonService _personService;

  ReferenceAccountMiddleware(this._personService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetReferenceAccountCommandAction) {
      final response = await _personService.getReferenceAccount(user: action.user);

      if (response is GetReferenceAccountSuccessResponse) {
        store.dispatch(GetReferenceAccountSuccessEventAction(response.referenceAccount));
      } else if (response is PersonServiceErrorResponse) {
        store.dispatch(GetReferenceAccountFailedEventAction());
      }
    }
  }
}
