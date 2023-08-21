import '../../models/categories/category.dart';
import '../../models/user.dart';

class GetCategoriesCommandAction {
  final User user;

  GetCategoriesCommandAction({required this.user});
}

class CategoriesLoadingEventAction {}
class CategoriesFailedEventAction {}
class WithCategoriesEventAction {
  final List<Category> categories;

  WithCategoriesEventAction({required this.categories});
}