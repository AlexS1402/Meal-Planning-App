import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:mealplanningapp/models/mealplan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlanDetails extends StatefulWidget {
  final MealPlan mealPlan;

  const MealPlanDetails({Key? key, required this.mealPlan}) : super(key: key);

  @override
  _MealPlanDetailsState createState() => _MealPlanDetailsState();
}

class _MealPlanDetailsState extends State<MealPlanDetails> {
  final ApiService _apiService = ApiService();
  late MealPlan _mealPlan;
  bool _isEditing = false;

  late TextEditingController _dateController;
  late TextEditingController _typeController;
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;

  @override
  void initState() {
    super.initState();
    _mealPlan = widget.mealPlan;
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.parse(_mealPlan.date)));
    _typeController = TextEditingController(text: _mealPlan.type);
    _nameController = TextEditingController(text: _mealPlan.name);
    _caloriesController = TextEditingController(text: _mealPlan.calories.toString());
    _proteinsController = TextEditingController(text: _mealPlan.proteins.toString());
    _carbsController = TextEditingController(text: _mealPlan.carbs.toString());
    _fatsController = TextEditingController(text: _mealPlan.fats.toString());
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveEdits() {
    _apiService.updateMealPlan({
      'id': _mealPlan.id,
      'userId': _mealPlan.userId,
      'date': _dateController.text,
      'type': _typeController.text,
      'name': _nameController.text,
      'calories': int.parse(_caloriesController.text),
      'proteins': int.parse(_proteinsController.text),
      'carbs': int.parse(_carbsController.text),
      'fats': int.parse(_fatsController.text),
    }).then((_) {
      Navigator.pop(context, true);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating meal plan: $error'))
      );
    });
  }

  void _cancelEdit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Meal Plan' : 'Meal Plan Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isEditing ? TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                ) : Text('Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_mealPlan.date))}'),
                _isEditing ? TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Type'),
                ) : Text('Type: ${_mealPlan.type}'),
                _isEditing ? TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ) : Text('Name: ${_mealPlan.name}'),
                _isEditing ? TextFormField(
                  controller: _caloriesController,
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ) : Text('Calories: ${_mealPlan.calories}'),
                _isEditing ? TextFormField(
                  controller: _proteinsController,
                  decoration: InputDecoration(labelText: 'Proteins (g)'),
                  keyboardType: TextInputType.number,
                ) : Text('Proteins: ${_mealPlan.proteins}g'),
                _isEditing ? TextFormField(
                  controller: _carbsController,
                  decoration: InputDecoration(labelText: 'Carbs (g)'),
                  keyboardType: TextInputType.number,
                ) : Text('Carbs: ${_mealPlan.carbs}g'),
                _isEditing ? TextFormField(
                  controller: _fatsController,
                  decoration: InputDecoration(labelText: 'Fats (g)'),
                  keyboardType: TextInputType.number,
                ) : Text('Fats: ${_mealPlan.fats}g'),
                SizedBox(height: 20),
                if (_isEditing) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveEdits,
                      child: Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: _cancelEdit,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
                if (!_isEditing) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleEditing,
                      child: Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () => _apiService.deleteMealPlan(_mealPlan.id).then((_) {
                        Navigator.pop(context);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting meal plan: $error'))
                        );
                      }),
                      child: Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
