import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../screens/meals.dart';

class MyController1 extends GetxController {
  final RxList<Category> availableCategories = <Category>[].obs;

  void Function(Meal) onToggleMealFavorite;

  MyController1({required this.onToggleMealFavorite});

  void selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Get.to(() => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: onToggleMealFavorite,
        ));
  }
}
