import '../../models/categories/category.dart';

class GetCategoriesCommandAction {
  GetCategoriesCommandAction();
}

class CategoriesLoadingEventAction {}
class CategoriesFailedEventAction {}
class WithCategoriesEventAction {
  final List<Category> categories;

  WithCategoriesEventAction({required this.categories});
}