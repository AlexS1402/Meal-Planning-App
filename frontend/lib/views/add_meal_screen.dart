import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealplanningapp/services/api/api_service.dart'; // Ensure this path matches your project structure
import 'package:mealplanningapp/models/recipe_model.dart'; // Ensure this path matches
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealplanningapp/services/user_service.dart';


class AddMealPlanScreen extends StatefulWidget {
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealPlanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String _mealType = 'Breakfast';
  DateTime selectedDate = DateTime.now();
  List<int> _selectedRecipes = [];
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  void _fetchRecipes() async {
    var recipes = await ApiService().fetchRecipes();
    setState(() {
      _recipes = recipes;
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _showRecipeSelector() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: _recipes.map((recipe) => CheckboxListTile(
                title: Text(recipe.title),
                value: _selectedRecipes.contains(recipe.id),
                onChanged: (bool? value) {
                  setState(() {
                    if (value!) {
                      if (!_selectedRecipes.contains(recipe.id)) {
                        _selectedRecipes.add(recipe.id!);
                      }
                    } else {
                      _selectedRecipes.remove(recipe.id);
                    }
                  });
                  (context as Element).markNeedsBuild();
                },
              )).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add Recipes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {}); // Refresh the state to update the UI after the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal Plan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _mealType,
              decoration: InputDecoration(labelText: 'Meal Type'),
              items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snack']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _mealType = newValue!;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recipes:', style: Theme.of(context).textTheme.subtitle1),
                  ..._selectedRecipes.map((id) => Text(
                    _recipes.firstWhere((recipe) => recipe.id == id).title,
                    style: Theme.of(context).textTheme.bodyText1,
                  )).toList(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showRecipeSelector,
                          child: Text('AddRecipes', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print("Submitting with title: ${_titleController.text}");
                            if (_formKey.currentState!.validate() && _selectedRecipes.isNotEmpty) {
                              ApiService().addMealPlan({
                                'userId': UserService.getUserId(),  // Replace with actual user ID
                                'name': _titleController.text,
                                'date': _dateController.text,
                                'type': _mealType,
                                'recipes': _selectedRecipes,
                              });
                            }
                          },
                          child: Text('Submit Meal Plan', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
