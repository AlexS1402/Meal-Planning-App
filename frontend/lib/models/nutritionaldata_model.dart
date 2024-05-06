class NutritionalDataModel {
  final String id;
  final String userId;  // To link the data to a specific user
  final DateTime date;  // The date for which the nutritional data applies
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;

  NutritionalDataModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  // Factory constructor to create a NutritionalDataModel from a map
  factory NutritionalDataModel.fromMap(Map<String, dynamic> map) {
    return NutritionalDataModel(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['dateConsumed']),
      calories: map['calories'],
      proteins: map['proteins'],
      carbs: map['carbs'],
      fats: map['fats'],
    );
  }

  // Method to convert NutritionalDataModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dateConsumed': date.toIso8601String(),
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }
}
