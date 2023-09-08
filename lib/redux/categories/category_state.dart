import 'package:equatable/equatable.dart';
import '../../models/categories/category.dart';

abstract class CategoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriesInitialState extends CategoriesState {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesErrorState extends CategoriesState {}

class CategoriesFetchedState extends CategoriesState {
  final List<Category> categories;

  CategoriesFetchedState(this.categories);

  @override
  List<Object?> get props => [categories];
}
