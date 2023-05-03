import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meals_app/controller/meal_detail_controller.dart';
import 'package:meals_app/screens/meal_details_screen.dart';
import 'package:meals_app/widgets/meal_item.dart';

import '../models/meal.dart';
import '../services/database_helper.dart';

class MealsScreen extends StatelessWidget {
  final MealsController controller = Get.put(MealsController());
  final db = DBHelper();

   MealsScreen(
      {super.key,
      required this.title,
      required this.meals,
      });

  final String? title;
  final List<Meal> meals;

  void selectedMeal(Meal meal) {
    Get.to(
      () => MealDetailScreen(
        meal: meal, onToggleFavorite: (Meal meal) async {
          await controller.getFavoriteMeals();
          },

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Oh Sorry',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          const SizedBox(
            height: 20.0,
          ),
          Text('Try Selecting different category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
        ],
      ),
    );
    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
            meal: meals[index],
            onSelectMeal: (meal) {
              selectedMeal(meal);
            }),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: content);
  }
}
