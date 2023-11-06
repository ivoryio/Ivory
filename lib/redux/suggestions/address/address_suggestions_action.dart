import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';

class FetchAddressSuggestionsCommandAction {
  final String query;

  const FetchAddressSuggestionsCommandAction({required this.query});
}

class AddressSuggestionsFetchedEventAction {
  final List<AddressSuggestion> suggestions;

  const AddressSuggestionsFetchedEventAction({required this.suggestions});
}

class AddressSuggestionsLoadingEventAction {}

class FetchAddressSuggestionsFailedEventAction {
  final AddressSuggestionsErrorType errorType;

  const FetchAddressSuggestionsFailedEventAction({required this.errorType});
}
