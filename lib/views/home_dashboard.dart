import 'package:flutter/material.dart';
import 'meal_plan_overview.dart';
import 'recipe_search.dart'; 

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanOverview()),
                );
              },
              child: const Text('View Meal Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeSearch()),
                );
              },
              child: const Text('Search Recipes'),
            ),
          ],
        ),
      ),
    );
  }
}
