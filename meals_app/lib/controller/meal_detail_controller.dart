import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../screens/meals.dart';
import '../services/database_helper.dart';

class MealsController extends GetxController {
  final RxList<Meal> availableMeals = <Meal>[].obs;
  final DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
   updateMeal();
  }

  updateMeal() async {
    await db.updateMealFavorite('m1', true);
  }







}
