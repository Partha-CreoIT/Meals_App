import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meals_app/models/category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/dummy_data.dart';
import '../models/meal.dart';

class DBHelper {
  static Database? _database;

  Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE category(id TEXT PRIMARY KEY, title TEXT)',
      );
      await db.execute(
        'CREATE TABLE meal(id TEXT PRIMARY KEY, categories TEXT, title TEXT, affordability TEXT, complexity TEXT,imageUrl TEXT,duration INTEGER, ingredients TEXT, steps TEXT, isGlutenFree INTEGER, isLactoseFree INTEGER, isVegan INTEGER, isVegetarian INTEGER , isFavorite INTEGER)',
      );
      await insertDummyData(db);
    });
  }

  Future<void> insertDummyData(Database db) async {
    await db.transaction((txn) async {
      for (final category in availableCategories) {
        await txn.insert('category', {
          'id': category.id,
          'title': category.title,
        });
      }

      for (final meal in dummyMeals) {
        await txn.insert('meal', {
          'id': meal.id,
          'categories': meal.categories.join(','),
          'title': meal.title,
          'affordability': meal.affordability
              .toString()
              .split('.')
              .last,
          'complexity': meal.complexity
              .toString()
              .split('.')
              .last,
          'imageUrl': meal.imageUrl,
          'duration': meal.duration,
          'ingredients': meal.ingredients.join(','),
          'steps': meal.steps.join(','),
          'isGlutenFree': meal.isGlutenFree ? 1 : 0,
          'isVegan': meal.isVegan ? 1 : 0,
          'isVegetarian': meal.isVegetarian ? 1 : 0,
          'isLactoseFree': meal.isLactoseFree ? 1 : 0,
          'isFavorite': meal.isFavorite ? 1 : 0,
        });
      }
    });
  }

  Future<void> updateCategory(Category category) async {
    final db = await getDatabase();
    await db.update(
      'category',
      {
        'id': category.id,
        'title': category.title,
      },
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await getDatabase();
    return await db.delete('category', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMeal(String id) async {
    final db = await getDatabase();
    return await db.delete('meal', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Category>> getAllCategories() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> maps = await database!.query('category');
    return List.generate(
      maps.length,
          (index) {
        return Category(
          id: maps[index]['id'],
          title: maps[index]['title'],
        );
      },
    );
  }

  Future<List<Meal>> getMeal() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> res= await database.rawQuery("SELECT * FROM meal WHERE isFavorite = 1");
    return List.generate(res.length, (index) {
      return Meal(
        id: res[index]['id'],
        isFavorite: res[index]['isFavorite'] == 1,
        categories: [],
        title: res[index]['title'],
        imageUrl: res[index]['imageUrl'],
        ingredients: [],
        steps: [],
        duration: 30,
        complexity : Complexity.challenging,
        affordability: Affordability.affordable,
        isGlutenFree: false,
        isLactoseFree: false,
        isVegan: false,
        isVegetarian: false,
      );
    });
  }


  Future<int> updateMealFavorite(String id, bool isFavorite) async {
    final db = await getDatabase();
    return await db.update(
      'meal',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<Map<String, dynamic>?> getCategoryById(String id) async {
    final db = await getDatabase();
    final result = await db.query('category', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getMealById(String id) async {
    final db = await getDatabase();
    final result = await db.query('meal', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }


}
