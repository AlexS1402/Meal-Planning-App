import 'package:flutter/material.dart';
import 'package:mealplanningapp/models/recipe_model.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Recipe _newRecipe = Recipe(id: 0, userId: 0, title: '', description: '', calories: 0, proteins: 0, carbs: 0, fats: 0);

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ApiService().addRecipe(_newRecipe.toJson()).then((result) {
        Navigator.pop(context);  // Return to previous screen after submission
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding recipe: $error'))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Recipe'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) => _newRecipe.title = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _newRecipe.description = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _newRecipe.calories = double.tryParse(value!) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Proteins (g)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _newRecipe.proteins = double.tryParse(value!) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Carbs (g)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _newRecipe.carbs = double.tryParse(value!) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fats (g)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _newRecipe.fats = double.tryParse(value!) ?? 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
