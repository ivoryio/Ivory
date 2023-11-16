import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/categories/category_action.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';

import '../../setup/authentication_helper.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'categories_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

  test("When asking to fetch for categories it should firstly display a loading state", () async {
    //given
    final store = createTestStore(
      categoriesService: FakeCategoryService(),
        initialState: createAppState(
          categoriesState: CategoriesInitialState(),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.categoriesState is CategoriesLoadingState);
    //when
    store.dispatch(GetCategoriesCommandAction());
    //then
    expect((await appState).categoriesState, isA<CategoriesLoadingState>());
  });

  test("When fetching categories fails it should display an error state", () async {
    //given
    final store = createTestStore(
        categoriesService: FakeFailingCategoriesService(),
        initialState: createAppState(
          categoriesState: CategoriesInitialState(),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.categoriesState is CategoriesErrorState);
    //when
    store.dispatch(GetCategoriesCommandAction());
    //then
    expect((await appState).categoriesState, isA<CategoriesErrorState>());
  });

  test("When fetching categories successfully it should display a categories list", () async {
    //given
    final store = createTestStore(
        categoriesService: FakeCategoryService(),
        initialState: createAppState(
          categoriesState: CategoriesInitialState(),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.categoriesState is CategoriesFetchedState);
    //when
    store.dispatch(GetCategoriesCommandAction());
    //then
    final CategoriesFetchedState categoriesFetchedState = (await appState).categoriesState as CategoriesFetchedState;
    expect((await appState).categoriesState, isA<CategoriesFetchedState>());
    expect(categoriesFetchedState.categories,  hasLength(3));
  });
}