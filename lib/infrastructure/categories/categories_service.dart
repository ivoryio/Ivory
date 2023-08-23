import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../models/user.dart';

class CategoriesService extends ApiService {
  CategoriesService({super.user});

  Future<CategoriesServiceResponse> getCategories({User? user}) async {
    if (user != null) {
      this.user = user;
    }

    try {
      final response = await get("/transactions/categories");
      final categories = (response as List).map((category) {
        final id = category["id"];
        final name = category["name"];

        return Category(id: id, name: name);
      }).toList();

      return GetCategoriesSuccessResponse(categories: categories);
    } catch (e) {
      return CategoriesServiceErrorResponse();
    }
  }
}

abstract class CategoriesServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCategoriesSuccessResponse extends CategoriesServiceResponse {
  final List<Category> categories;

  GetCategoriesSuccessResponse({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoriesServiceErrorResponse extends CategoriesServiceResponse {}
