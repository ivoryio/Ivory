import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';

abstract class CitySuggestionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CitySuggestionsFetchedState extends CitySuggestionsState {
  final List<String> cities;
  final String? searchTerm;

  CitySuggestionsFetchedState({required this.cities, this.searchTerm});

  @override
  List<Object> get props => [cities];
}

class CitySuggestionsInitialState extends CitySuggestionsState {}

class CitySuggestionsLoadingState extends CitySuggestionsState {}

class CitySuggestionsErrorState extends CitySuggestionsState {
  final CitySuggestionsErrorType errorType;
  final String? searchTerm;

  CitySuggestionsErrorState({required this.errorType, this.searchTerm});

  @override
  List<Object> get props => [errorType];
}
