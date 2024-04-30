import 'package:flutter/material.dart';
import 'package:mealplanningapp/models/recipe_model.dart';  // Ensure the Recipe model is imported
import 'package:mealplanningapp/services/api/api_service.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() async {
    try {
      recipes = await ApiService().fetchRecipes();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Error handling
      showErrorDialog(e.toString());
    }
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(recipe.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Description: ${recipe.description}'),
            Text('Calories: ${recipe.calories.toString()}'),
            Text('Proteins: ${recipe.proteins.toString()}g'),
            Text('Carbs: ${recipe.carbs.toString()}g'),
            Text('Fats: ${recipe.fats.toString()}g'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Edit'),
          onPressed: () {
            Navigator.of(ctx).pop();
            _editRecipe(context, recipe);
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () {
            Navigator.of(ctx).pop();
            _deleteRecipe(context, recipe.id);
          },
        ),
      ],
    ),
  );
}

void _addRecipe() {
  final _formKey = GlobalKey<FormState>();
  Recipe newRecipe = Recipe(id: 0, title: '', description: '', calories: 0, proteins: 0, carbs: 0, fats: 0);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Add New Recipe'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  newRecipe.title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  newRecipe.description = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newRecipe.calories = double.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Proteins (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newRecipe.proteins = double.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newRecipe.carbs = double.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newRecipe.fats = double.parse(value ?? '0');
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(ctx).pop();
              _saveRecipe(newRecipe);
            }
          },
        ),
      ],
    ),
  );
}

void _saveRecipe(Recipe recipe) {
  ApiService().addRecipe({
    'title': recipe.title,
    'description': recipe.description,
    'calories': recipe.calories,
    'proteins': recipe.proteins,
    'carbs': recipe.carbs,
    'fats': recipe.fats,
  }).then((_) {
    setState(() {
      recipes.add(recipe);
      loadRecipes(); // Reload the recipes to include the new one
    });

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch recipes: $message'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(recipes[i].title),
                subtitle: Text('Calories: ${recipes[i].calories}'),
                onTap: () => {
                  // Assuming _showRecipeDetails is implemented to show more info
                  _showRecipeDetails(context, recipes[i])
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addRecipe(),  // Assuming _addRecipe is a method that handles adding a recipe
      ),
    );
  }

  void _addRecipe() {
    // Implement the logic to add a recipe
  }
}
