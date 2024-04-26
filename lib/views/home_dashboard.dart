import 'package:flutter/material.dart';
import 'meal_plan_overview.dart';
import 'recipe_search.dart';
import 'shopping_list.dart';
import 'nutritional_tracking.dart';
import 'settings_profile.dart';
import 'feedback_support.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsProfile()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 1.5,
        children: <Widget>[
          _buildNavigationButton(context, 'Meal Plan', Icons.calendar_today, MealPlanOverview()),
          _buildNavigationButton(context, 'Recipes', Icons.book, RecipeSearch()),
          _buildNavigationButton(context, 'Shopping List', Icons.shopping_cart, ShoppingList()),
          _buildNavigationButton(context, 'Nutrition', Icons.show_chart, NutritionalTracking()),
          _buildNavigationButton(context, 'Feedback', Icons.feedback, FeedbackSupport()),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String title, IconData icon, Widget destination) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
