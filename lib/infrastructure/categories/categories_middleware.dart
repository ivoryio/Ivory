import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/redux/categories/category_action.dart';

import '../../redux/app_state.dart';
import '../../redux/auth/auth_state.dart';

class GetCategoriesMiddleware extends  MiddlewareClass<AppState> {
  final CategoriesService _categoriesService;

  GetCategoriesMiddleware(this._categoriesService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if(action is GetCategoriesCommandAction) {
      store.dispatch(CategoriesLoadingEventAction());

      final response = await _categoriesService.getCategories(user: authState.authenticatedUser.cognito);
      if(response is GetCategoriesSuccessResponse) {
        store.dispatch(WithCategoriesEventAction(categories: response.categories));
      } else {
        store.dispatch(CategoriesFailedEventAction());
      }
    }
  }
}