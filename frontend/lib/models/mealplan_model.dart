class MealPlan {
  final int id;
  final int userId;
  final String date;
  final String type;
  final String name;
  final int calories;
  final int proteins;
  final int carbs;
  final int fats;

  MealPlan({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['userId'].toString()),
      date: json['date'],
      type: json['type'],
      name: json['name'],
      calories: int.parse(json['calories'].toString()),
      proteins: int.parse(json['proteins'].toString()),
      carbs: int.parse(json['carbs'].toString()),
      fats: int.parse(json['fats'].toString()),
    );
  }
}
