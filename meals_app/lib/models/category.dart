import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  final Color color;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        title: json['title'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'],
        title: map['title'],
      );

  @override
  String toString() {
    return 'Category{id: $id , title:$title}';
  }
}
