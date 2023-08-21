import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/models/user.dart';

class FakeCategoryService extends CategoriesService {
  @override
  Future<CategoriesServiceResponse> getCategories({User? user}) async {
    return GetCategoriesSuccessResponse(categories: [
      Category(id: "id1", name: "ATM"),
      Category(id: "id2", name: "Food&Drink"),
      Category(id: "id3", name: "Upcoming transfer"),
    ],);
  }
}

class FakeFailingCategoriesService extends CategoriesService {
  @override
  Future<CategoriesServiceResponse> getCategories({User? user}) async {
    return CategoriesServiceErrorResponse();
  }
}