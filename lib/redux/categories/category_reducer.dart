import 'package:solarisdemo/redux/categories/category_action.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';

CategoriesState categoriesReducer(CategoriesState currentState, dynamic action) {
  if (action is CategoriesLoadingEventAction) {
    return CategoriesLoadingState();
  } else if (action is CategoriesFailedEventAction) {
    return CategoriesErrorState();
  } else if (action is WithCategoriesEventAction) {
    return CategoriesFetchedState(action.categories);
  }

  return currentState;
}