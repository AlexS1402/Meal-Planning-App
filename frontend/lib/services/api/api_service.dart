import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mealplanningapp/models/recipe_model.dart';
import 'package:mealplanningapp/models/mealplan_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.215:3001'; // Adjust as needed

  //method to fetch recipes
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

  //method to add recipes
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

  //method to update recipes
  Future<void> updateRecipe(Map<String, dynamic> recipeData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/recipes/${recipeData['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(recipeData),
      );
      if (response.statusCode != 200) {
        print('Failed to update recipe: ${response.body}');
        throw Exception(
            'Failed to update recipe: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error making API call: $e');
      throw Exception('Error making API call: $e');
    }
  }

  //method to delete recipes
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

  //method to search for recipes
  Future<List<Recipe>> searchRecipes(String query, int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes?search=$query&page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Recipe> recipes =
          body.map((dynamic item) => Recipe.fromJson(item)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<MealPlan>> fetchMealPlans(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mealplans/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => MealPlan.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load meal plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to make API call: $e');
    }
  }

  Future<void> addMealPlan(Map<String, dynamic> mealPlanData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mealplans'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mealPlanData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add meal plan');
    }
  }

  Future<void> updateMealPlan(int id, Map<String, dynamic> mealPlanData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mealplans/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mealPlanData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update meal plan');
    }
  }

  Future<void> deleteMealPlan(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/mealplans/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal plan');
    }
  }

  Future<void> markAsConsumed(MealPlan mealPlan) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mealplans/markConsumed/${mealPlan.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': mealPlan.userId, // Assuming the userId is known
          'dateConsumed': DateTime.now().toString().substring(0, 10),
          'calories': mealPlan.calories,
          'proteins': mealPlan.proteins,
          'carbs': mealPlan.carbs,
          'fats': mealPlan.fats
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to mark meal as consumed');
      }
    } catch (e) {
      throw Exception('Error making API call: $e');
    }
  }

  void confirmMarkAsConsumed(BuildContext context, MealPlan mealPlan) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text(
              "Are you sure you want to mark ${mealPlan.name} as consumed? It will be added to your nutritional data."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                markAsConsumed(mealPlan); // Proceed to mark as consumed, passing context
              },
            ),
          ],
        );
      },
    );
  }
}
