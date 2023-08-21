import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'categories_mocks.dart';

void main() {
  test("When asking to fetch for categories it should firstly display a loading state", () async {
    //given
    final store = createTestStore(
      categoriesService: FakeCategoryService(),
        initialState: createAppState(
          categoriesState: CategoriesInitialState(),
        ));
    //when
    //then
  });
}