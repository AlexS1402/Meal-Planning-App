import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mealplanningapp/models/recipe_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.215:3001';  // Adjust as needed

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

  Future<void> addRecipe(Map<String, dynamic> recipeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(recipeData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add recipe');
    }
  }

  Future<void> updateRecipe(Map<String, dynamic> recipeData) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/recipes/${recipeData['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(recipeData),
    );
    if (response.statusCode != 200) {
      print('Failed to update recipe: ${response.body}');
      throw Exception('Failed to update recipe: Status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error making API call: $e');
    throw Exception('Error making API call: $e');
  }
}

  Future<void> deleteRecipe(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete recipe');
      }
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }

  Future<List<Recipe>> searchRecipes(String query, int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes?search=$query&page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes = body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}