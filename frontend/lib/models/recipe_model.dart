class Recipe {
  int id;
  int userId; // Ensure this is not null
  String title;
  String description;
  double calories;
  double proteins;
  double carbs;
  double fats;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      userId: json['userId'] ?? 1, // Fallback to 1 if null
      title: json['title'] as String,
      description: json['description'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }
}
