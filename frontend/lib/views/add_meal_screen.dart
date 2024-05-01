import 'package:flutter/material.dart';

class AddMealPlan extends StatefulWidget {
  @override
  _AddMealPlanState createState() => _AddMealPlanState();
}

class _AddMealPlanState extends State<AddMealPlan> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'YYYY-MM-DD',
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Meal Type',
                hintText: 'e.g., Breakfast, Lunch, Dinner',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addMealPlan(),
              child: Text('Add Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }

  void _addMealPlan() {
    // Logic to handle adding a meal plan
    // This might involve sending a request to your backend
    print('Adding Meal Plan: Date: ${_dateController.text}, Type: ${_typeController.text}');
    Navigator.pop(context);  // Optionally pop back after adding
  }
}
