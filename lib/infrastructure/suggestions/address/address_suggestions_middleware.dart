import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_action.dart';

class AddressSuggestionsMiddleware extends MiddlewareClass<AppState> {
  final AddressSuggestionsService _addressSuggestionsService;

  AddressSuggestionsMiddleware(this._addressSuggestionsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is FetchAddressSuggestionsCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(AddressSuggestionsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final response = await _addressSuggestionsService.getAddressSuggestions(
          user: user,
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
}
