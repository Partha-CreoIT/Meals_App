import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meals_app/controller/controller_fetch.dart';
import '../controller/controller_category.dart';
import '../data/dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../services/database_helper.dart';
import '../widgets/category_grid_item.dart';
import 'meals.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.onToggleFavorite});

  final void Function(Meal meal) onToggleFavorite;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final MyController controller = Get.put(MyController());
  final MyController1 controller1 = Get.put(MyController1());
  final db = DBHelper();

  fetchCat() async {
    final categories = await db.getAllCategories();
    return categories;
  }
  void selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Get.to(() => MealsScreen(
      title: category.title,
      meals: filteredMeals,
      onToggleFavorite: widget.onToggleFavorite
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () {
            if (controller.categories.isNotEmpty) {
              return GridView(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                children: [
                  for (final category in availableCategories)
                    CategoryGridItem(
                      category: category,
                      onSelect: () {
                        controller1.selectCategory(context , category );
                      },
                    )
                ],
              );
            } else {
              return const Center(
                child: Text('No categories found.'),
              );
            }

          },
        ),
      ),
    );
  }

/*@override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCat(),
      builder: (BuildContext context,snapshot) {
        if (snapshot.hasData) {
          return GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            children: [
              for (final category in availableCategories)
                CategoryGridItem(
                    category: category,
                    onSelect: () {
                      _selectCategory(context, category);
                    })
            ],
          );
        }
        return Container(
          child: CircularProgressIndicator(),
        );
      },
    );*/
}
