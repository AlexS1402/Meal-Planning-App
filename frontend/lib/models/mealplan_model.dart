import 'meal_model.dart';

class MealPlanModel {
  final String id;
  final DateTime date;
  final List<MealModel> meals; 
  final double totalCalories;

  MealPlanModel({
    required this.id,
    required this.date,
    required this.meals,
    required this.totalCalories,
  });

// Factory constructor to create a MealPlanModel from a map
  factory MealPlanModel.fromMap(Map<String, dynamic> map) {
    return MealPlanModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      meals: (map['meals'] as List<dynamic>).map((meal) => MealModel.fromMap(meal)).toList(),
      totalCalories: map['totalCalories'],
    );
  }

// Method to convert MealPlanModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'meals': meals.map((meal) => meal.toMap()).toList(),
      'totalCalories': totalCalories,
    };
  }
}