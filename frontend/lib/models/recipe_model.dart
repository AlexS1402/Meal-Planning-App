class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final int calories; // Caloric content per serving

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.calories,
  });
}
