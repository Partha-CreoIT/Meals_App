import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meals_app/controller/category_controller.dart';

import '../data/dummy_data.dart';
import '../models/meal.dart';
import '../services/database_helper.dart';
import '../widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.onToggleFavorite});

  final void Function(Meal meal) onToggleFavorite;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final MyController controller = Get.put(MyController());
  final db = DBHelper();

  fetchCat() async {
    final categories = await db.getAllCategories();
    return categories;
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
                        controller.selectCategory(category);
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
}
