class MealModel {
  final String id;
  final String type; // Example: 'Breakfast', 'Lunch', 'Dinner'
  final List<String> recipes; // List of recipe IDs
  final String time; // Scheduled time for the meal

  MealModel({
    required this.id,
    required this.type,
    required this.recipes,
    required this.time,
  });

  // Convert MealModel to a map for storage or network transmission
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'recipes': recipes,
      'time': time,
    };
  }

  // Create a MealModel from a map
  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      type: map['type'],
      recipes: List<String>.from(map['recipes']),
      time: map['time'],
    );
  }
}
