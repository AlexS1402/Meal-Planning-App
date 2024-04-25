import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final String recipeTitle; // Placeholder title, typically passed in via constructor

  RecipeDetails({required this.recipeTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/recipe.jpg'), // Placeholder image, replace with actual image path
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('List of ingredients here...'), // Placeholder for ingredients list
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Step-by-step cooking instructions here...'), // Placeholder for instructions
            ),
          ],
        ),
      ),
    );
  }
}
