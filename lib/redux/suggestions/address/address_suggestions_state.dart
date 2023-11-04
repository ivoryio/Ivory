import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/suggestions/address_suggestions_error_type.dart';

abstract class AddressSuggestionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddressSuggestionsFetchedState extends AddressSuggestionsState {
  final List<AddressSuggestion> suggestions;

  AddressSuggestionsFetchedState({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

class AddressSuggestionsInitialState extends AddressSuggestionsState {}

class AddressSuggestionsLoadingState extends AddressSuggestionsState {}

class AddressSuggestionsErrorState extends AddressSuggestionsState {
  final AddressSuggestionsErrorType errorType;

  AddressSuggestionsErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
