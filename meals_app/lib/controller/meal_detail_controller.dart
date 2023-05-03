import 'package:get/get.dart';

import '../models/meal.dart';
import '../services/database_helper.dart';

class MealsController extends GetxController {
  final RxList<Meal> availableMeals = <Meal>[].obs;
  final DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
    getFavoriteMeals();
  }


  updateMeal() async {
   await db.updateMealFavorite('m1', true);
  }
  updateMeals() async {
    await db.updateMealFavorite('m2', true);
  }

  Future<void> getFavoriteMeals() async {
    final List<Meal> favoriteMeals = await db.getMeal();
    availableMeals.assignAll(favoriteMeals);
    print(availableMeals);
  }
}
