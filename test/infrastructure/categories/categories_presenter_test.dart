import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/categories/categories_presenter.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';

void main() {
  const Category category1 = Category(id: "id1", name: "ATM");
  const Category category2 = Category(id: "id2", name: "Food&Drink");
  const Category category3 = Category(id: "id3", name: "Upcoming transfer");

  final List<Category> categories = [category1,category2,category3];

  test("When fetching categories is in progress should return loading", () {
    //given
    final categoriesState = CategoriesLoadingState();
    //when
    final viewModel = CategoriesPresenter.presentCategories(categoriesState: categoriesState);
    //then
    expect(viewModel, CategoriesLoadingViewModel());
  });

  test("When fetching categories fails should return error", () {
    //given
    final categoriesState = CategoriesErrorState();
    //when
    final viewModel = CategoriesPresenter.presentCategories(categoriesState: categoriesState);
    //then
    expect(viewModel, CategoriesErrorViewModel());
  });

  test("When fetching categories is successful should return a categories list", () {
    //given
    final categoriesState = CategoriesFetchedState(categories);
    //when
    final viewModel = CategoriesPresenter.presentCategories(categoriesState: categoriesState);
    //then
    expect(viewModel, WithCategoriesViewModel(categories: categories));
  });
}