import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_service.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_action.dart';

class AddressSuggestionsMiddleware extends MiddlewareClass<AppState> {
  final AddressSuggestionsService _addressSuggestionsService;

  AddressSuggestionsMiddleware(this._addressSuggestionsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    User cognitoUser;

    if (authState is AuthenticationInitializedState) {
      cognitoUser = authState.cognitoUser;
    } else if (authState is AuthenticatedState) {
      cognitoUser = authState.authenticatedUser.cognito;
    } else {
      return;
    }

    if (action is FetchAddressSuggestionsCommandAction) {
      store.dispatch(AddressSuggestionsLoadingEventAction());

      final response = await _addressSuggestionsService.getAddressSuggestions(
        user: cognitoUser,
        query: action.query,
      );

      if (response is GetAddressSuggestionsSuccessResponse) {
        store.dispatch(AddressSuggestionsFetchedEventAction(suggestions: response.suggestions));
      } else if (response is GetAddressSuggestionsErrorResponse) {
        store.dispatch(FetchAddressSuggestionsFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
