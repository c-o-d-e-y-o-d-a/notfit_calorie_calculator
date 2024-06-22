import 'package:flutter/material.dart';
import 'package:calorie_calc/models/food_model.dart';

class FoodController extends ChangeNotifier {
  final Map<Food, double> _selectedFoods = {};

  void setQuantity(Food food, double quantity) {
    if (quantity > 0) {
      _selectedFoods[food] = quantity;
    } else {
      _selectedFoods.remove(food);
    }
    notifyListeners();
  }

  void clearAll() {
    _selectedFoods.clear();
    notifyListeners();
  }

  double getQuantity(Food food) {
    return _selectedFoods[food] ?? 0;
  }

  double totalCalories() {
    double total = 0;
    _selectedFoods.forEach((food, quantity) {
      total += food.caloriesPerUnit * quantity;
    });
    return total;
  }

  Map<Food, double> get selectedFoods => _selectedFoods;
}
