class IngredientModel {
  final String id;
  final String name;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;

  IngredientModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  // Factory constructor to create an IngredientModel from a map
  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      proteins: map['proteins'],
      carbs: map['carbs'],
      fats: map['fats'],
    );
  }

  // Method to convert IngredientModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }
}
