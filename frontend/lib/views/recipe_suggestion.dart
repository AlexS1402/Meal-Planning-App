import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mealplanningapp/services/api/api_service.dart';


class RecipeSuggestion extends StatefulWidget {
  const RecipeSuggestion({super.key});

  @override
  _RecipeSuggestionScreenState createState() => _RecipeSuggestionScreenState();
}

class _RecipeSuggestionScreenState extends State<RecipeSuggestion> {
  List<TextEditingController> _controllers = [TextEditingController()];

  void _addNewIngredientField() {
    if (_controllers.length < 15) {
      setState(() {
        _controllers.add(TextEditingController());
      });
    }
  }

  Future<void> _submitIngredients() async {
    List<String> ingredients = _controllers.map((controller) => controller.text.trim()).where((ingredient) => ingredient.isNotEmpty).toList();
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.215:3001/recipes/suggest-recipes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}),
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Recipe Suggestions'),
            content: Text(json.decode(response.body)['recipes']),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load recipe suggestions');
      }
    } catch (error) {
      print('Failed to get suggestions: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch recipes!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Suggestions'),
      ),
      body: Column(
        children: <Widget>[
          Text('Enter Ingredients:'),
          Expanded(
            child: ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (ctx, index) {
                return TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    hintText: 'Ingredient ${index + 1}',
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.add, color: Colors.green),
                label: Text('Add Another Ingredient'),
                onPressed: _addNewIngredientField,
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: _submitIngredients,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
