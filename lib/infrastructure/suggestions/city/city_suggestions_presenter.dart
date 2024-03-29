import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/city_suggestions_error_type.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_state.dart';

class CitySuggestionsPresenter {
  static CitySuggestionsViewModel present({required CitySuggestionsState citySuggestionsState}) {
    if (citySuggestionsState is CitySuggestionsLoadingState) {
      return CitySuggestionsLoadingViewModel();
    } else if (citySuggestionsState is CitySuggestionsFetchedState) {
      return CitySuggestionsFetchedViewModel(
        cities: citySuggestionsState.cities,
        searchTerm: citySuggestionsState.searchTerm,
      );
    } else if (citySuggestionsState is CitySuggestionsErrorState) {
      return CitySuggestionsErrorViewModel(
        errorType: citySuggestionsState.errorType,
        searchTerm: citySuggestionsState.searchTerm,
      );
    }

    return CitySuggestionsInitialViewModel();
  }
}

abstract class CitySuggestionsViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class CitySuggestionsInitialViewModel extends CitySuggestionsViewModel {}

class CitySuggestionsLoadingViewModel extends CitySuggestionsViewModel {}

class CitySuggestionsFetchedViewModel extends CitySuggestionsViewModel {
  final List<String> cities;
  final String? searchTerm;

  CitySuggestionsFetchedViewModel({required this.cities, this.searchTerm});

  @override
  List<Object> get props => [cities];
}

class CitySuggestionsErrorViewModel extends CitySuggestionsViewModel {
  final String? searchTerm;
  final CitySuggestionsErrorType errorType;

  CitySuggestionsErrorViewModel({required this.errorType, this.searchTerm});

  @override
  List<Object> get props => [errorType];
}
