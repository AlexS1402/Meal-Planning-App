import 'package:flutter/material.dart';
import 'package:mealplanningapp/models/recipe_model.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Recipe _editableRecipe;
  bool _isEditing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _editableRecipe = Recipe(
      id: widget.recipe.id,
      userId: widget.recipe.userId,
      title: widget.recipe.title,
      description: widget.recipe.description,
      calories: widget.recipe.calories,
      proteins: widget.recipe.proteins,
      carbs: widget.recipe.carbs,
      fats: widget.recipe.fats,
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    ApiService().updateRecipe(_editableRecipe.toJson()).then((_) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update Successful"),
            content: const Text("The recipe has been successfully updated."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Pop the dialog first
                  Navigator.of(context).pop();
                  // Then pop the current screen with updated recipe data
                  Navigator.pop(context, _editableRecipe);
                },
                child: const Text("OK"),
              ),
            ],
          );
        }
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating recipe: $error'))
      );
    });
  }
}

  void _cancelEdit() {
    setState(() {
      _editableRecipe = widget.recipe;
      _isEditing = false;
    });
  }

  void _deleteRecipe() {
    print('Attempting to delete recipe with ID: ${widget.recipe.id}');
    ApiService().deleteRecipe(widget.recipe.id).then((_) {
      print('Recipe deleted successfully');
      Navigator.pop(context);
    }).catchError((error) {
      print('Error deleting recipe: $error'); // Log the detailed error
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting recipe: $error'))
    );
  });
}

  @override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_isEditing ? 'Edit Recipe' : 'Recipe Details'),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.title,
                            decoration: InputDecoration(labelText: 'Title'),
                            onSaved: (value) => _editableRecipe.title = value!,
                            validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                        ) : Text('Title: ${_editableRecipe.title}', style: TextStyle(fontSize: 18)),
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.description,
                            decoration: InputDecoration(labelText: 'Description'),
                            onSaved: (value) => _editableRecipe.description = value!,
                            validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                        ) : Text('Description: ${_editableRecipe.description}', style: TextStyle(fontSize: 18)),
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.calories.toString(),
                            decoration: InputDecoration(labelText: 'Calories'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _editableRecipe.calories = double.parse(value!),
                        ) : Text('Calories: ${_editableRecipe.calories}', style: TextStyle(fontSize: 18)),
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.proteins.toString(),
                            decoration: InputDecoration(labelText: 'Proteins (g)'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _editableRecipe.proteins = double.parse(value!),
                        ) : Text('Proteins: ${_editableRecipe.proteins}g', style: TextStyle(fontSize: 18)),
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.carbs.toString(),
                            decoration: InputDecoration(labelText: 'Carbs (g)'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _editableRecipe.carbs = double.parse(value!),
                        ) : Text('Carbs: ${_editableRecipe.carbs}g', style: TextStyle(fontSize: 18)),
                        _isEditing ? TextFormField(
                            initialValue: _editableRecipe.fats.toString(),
                            decoration: InputDecoration(labelText: 'Fats (g)'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _editableRecipe.fats = double.parse(value!),
                        ) : Text('Fats: ${_editableRecipe.fats}g', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 20),
                        if (_isEditing) ElevatedButton(
                            onPressed: _saveChanges,
                            child: Text('Save'),
                        ),
                        if (_isEditing) ElevatedButton(
                            onPressed: _cancelEdit,
                            child: Text('Cancel'),
                        ),
                    ],
                ),
            ),
        ),
        bottomNavigationBar: _isEditing ? null : BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    ElevatedButton(
                        onPressed: _toggleEdit,
                        child: Text('Edit'),
                    ),
                    ElevatedButton(
                        onPressed: _deleteRecipe,
                        child: Text('Delete'),
                    ),
                ],
            ),
        ),
    );
}
}
