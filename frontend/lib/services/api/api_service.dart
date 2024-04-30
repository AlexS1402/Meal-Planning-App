import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mealplanningapp/models/recipe_model.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000';  // Adjust as needed

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Recipe.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to make API call: $e');
    }
  }
}
