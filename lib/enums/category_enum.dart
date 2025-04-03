import 'package:flutter/material.dart';

enum CategoryEnum {
  food(Icons.food_bank_outlined, "Food"),
  drink(Icons.local_drink_outlined, "Drink"),
  other(Icons.category, "Other");

  final IconData icon;
  final String label;

  const CategoryEnum(this.icon, this.label);

  static CategoryEnum fromString(String value) {
    return CategoryEnum.values.firstWhere(
          (category) => category.label.toLowerCase() == value.toLowerCase(),
      orElse: () => CategoryEnum.other,
    );
  }
}