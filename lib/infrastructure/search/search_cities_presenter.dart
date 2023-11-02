import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/search/search_cities_state.dart';

class SearchCitiesPresenter {
  static SearchCitiesViewModel present({required SearchCitiesState searchCitiesState}) {
    if (searchCitiesState is SearchCitiesLoadingState) {
      return SearchCitiesLoadingViewModel();
    } else if (searchCitiesState is SearchCitiesFetchedState) {
      return SearchCitiesFetchedViewModel(cities: searchCitiesState.cities, searchTerm: searchCitiesState.searchTerm);
    } else if (searchCitiesState is SearchCitiesErrorState) {
      return SearchCitiesErrorViewModel();
    }

    return SearchCitiesInitialViewModel();
  }
}

abstract class SearchCitiesViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchCitiesInitialViewModel extends SearchCitiesViewModel {}

class SearchCitiesLoadingViewModel extends SearchCitiesViewModel {}

class SearchCitiesFetchedViewModel extends SearchCitiesViewModel {
  final List<String> cities;
  final String? searchTerm;

  SearchCitiesFetchedViewModel({required this.cities, this.searchTerm});

  @override
  List<Object> get props => [cities];
}

class SearchCitiesErrorViewModel extends SearchCitiesViewModel {}
