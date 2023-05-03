import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/meal_detail_controller.dart';
import '../models/meal.dart';
import '../services/database_helper.dart';
import 'categories.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final MealsController mealsController = Get.put(MealsController());
  final db = DBHelper();
  int _selectedPageIndex = 0;
  String _pageTitle = 'Categories';

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageTitle = index == 0 ? 'Categories' : 'Your Favorite Meal';
    });
  }

  Widget _buildPageContent(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return const CategoriesScreen();
      case 1:
        return Obx(() {
          final List<Meal> favoriteMeals = mealsController.availableMeals;

          if (favoriteMeals.isEmpty) {
            return const Center(
              child: Text('No favorite meals.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteMeals.length,
            itemBuilder: (context, index) {
              final Meal meal = favoriteMeals[index];

              return ListTile(
                leading: Image.network(meal.imageUrl),
                title: Text(
                  meal.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(meal.categories.join(', ')),
                trailing: IconButton(
                    icon: Icon(meal.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border ,  color: Colors.red ),
                    onPressed: () => mealsController.getFavoriteMeals()),
              );
            },
          );
        });
      default:
        return const Center(child: Text('Error!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
      ),
      body: _buildPageContent(_selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
