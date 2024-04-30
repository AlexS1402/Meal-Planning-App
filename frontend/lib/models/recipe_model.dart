class Recipe {
  final int id;
  final String title;
  final String description;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      calories: json['calories'],
      proteins: json['proteins'],
      carbs: json['carbs'],
      fats: json['fats'],
    );
  }
}
