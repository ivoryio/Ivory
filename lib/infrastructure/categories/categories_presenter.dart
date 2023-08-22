import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';

class CategoriesPresenter {
  static CategoriesViewModel presentCategories({required CategoriesState categoriesState}) {
    if(categoriesState is CategoriesLoadingState) {
      return CategoriesLoadingViewModel();
    } else if (categoriesState is CategoriesErrorState) {
      return CategoriesErrorViewModel();
    } else if (categoriesState is CategoriesFetchedState) {
      return WithCategoriesViewModel(categories: categoriesState.categories);
    }

    return CategoriesInitialViewModel();
  }
}

abstract class CategoriesViewModel extends Equatable{
  final List<Category>? categories;

  const CategoriesViewModel({this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoriesInitialViewModel extends CategoriesViewModel {}
class CategoriesLoadingViewModel extends CategoriesViewModel {}
class CategoriesErrorViewModel extends CategoriesViewModel {}

class WithCategoriesViewModel extends CategoriesViewModel {
  const WithCategoriesViewModel({
    required List<Category>? categories
  }) : super (categories: categories);
}
