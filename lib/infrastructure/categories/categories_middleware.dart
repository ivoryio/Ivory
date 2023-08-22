import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/redux/categories/category_action.dart';

import '../../redux/app_state.dart';

class GetCategoriesMiddleware extends  MiddlewareClass<AppState> {
  final CategoriesService _categoriesService;

  GetCategoriesMiddleware(this._categoriesService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if(action is GetCategoriesCommandAction) {
      store.dispatch(CategoriesLoadingEventAction());

      final response = await _categoriesService.getCategories(user: action.user);
      if(response is GetCategoriesSuccessResponse) {
        store.dispatch(WithCategoriesEventAction(categories: response.categories));
      } else {
        store.dispatch(CategoriesFailedEventAction());
      }
    }
  }
}