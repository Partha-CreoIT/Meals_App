import 'package:get/get.dart';
import 'package:meals_app/services/database_helper.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../screens/meals.dart';

class MyController extends GetxController {
  RxList<Category> categories = RxList<Category>();
  final DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
    fetchCat();
  }

  fetchCat() async {
    List<Category> data = await db.getAllCategories();
    categories.assignAll(data);
  }

  void selectCategory(Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Get.to(() => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: (Meal meal) {},
        ));
  }
}
