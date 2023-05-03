import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/favorite_detail_controller.dart';
import '../models/meal.dart';
import '../services/database_helper.dart';
import 'categories.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final FavoriteMealController mealsController =
      Get.put(FavoriteMealController());
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
        mealsController.getFavoriteMeals();
        return Obx(() {
          final List<Meal> favoriteMeals = mealsController.availableMeals;

          if (favoriteMeals.isEmpty) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No favorite meals.' , style: TextStyle(color: Colors.white  ,fontSize: 18 , ),),
                  SizedBox(height: 20,),
                  Text('Try To Add Some Meals.' , style: TextStyle(color: Colors.white  ,fontSize: 18 , ),),
                ],
              ),

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
        title: Text(
          _pageTitle,
        ),
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
