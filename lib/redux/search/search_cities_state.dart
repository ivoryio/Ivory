import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/search/search_cities_error_type.dart';

abstract class SearchCitiesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchCitiesFetchedState extends SearchCitiesState {
  final List<String> cities;
  final String? searchTerm;

  SearchCitiesFetchedState({required this.cities, this.searchTerm});

  @override
  List<Object> get props => [cities];
}

class SearchCitiesInitialState extends SearchCitiesState {}

class SearchCitiesLoadingState extends SearchCitiesState {}

class SearchCitiesErrorState extends SearchCitiesState {
  final SearchCitiesErrorType errorType;

  SearchCitiesErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
