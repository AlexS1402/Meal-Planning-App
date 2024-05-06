import 'package:flutter/material.dart';
import 'meal_plan_overview.dart';
import 'recipe_search.dart';
import 'recipe_suggestion.dart';
import 'nutritional_tracking.dart';
import 'settings_profile.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MealPlanOverview(),
    RecipeSearch(),
    RecipeSuggestion(),
    NutritionalTracking(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        centerTitle: true,
        
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
            // This should navigate to your settings/profile page
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsProfile()));
          },
        ),
      ],
    ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Suggestions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.blender),
            label: 'Nutrition',
          ),     
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}