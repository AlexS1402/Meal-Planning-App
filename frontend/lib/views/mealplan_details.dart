import 'package:flutter/material.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:mealplanningapp/models/mealplan_model.dart';

class MealPlanDetails extends StatefulWidget {
  final MealPlan mealPlan;

  const MealPlanDetails({Key? key, required this.mealPlan}) : super(key: key);

  @override
  _MealPlanDetailsState createState() => _MealPlanDetailsState();
}

class _MealPlanDetailsState extends State<MealPlanDetails> {
  final ApiService _apiService = ApiService();
  late MealPlan _mealPlan;

  @override
  void initState() {
    super.initState();
    _mealPlan = widget.mealPlan;
  }

  void _deleteMealPlan() async {
    try {
      await _apiService.deleteMealPlan(_mealPlan.id);
      Navigator.of(context).pop(); // Assuming deletion is successful, go back to the previous screen
    } catch (e) {
      _showErrorDialog('Failed to delete meal plan: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_mealPlan.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit meal plan page or show edit form
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteMealPlan,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date: ${_mealPlan.date}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Type: ${_mealPlan.type}', style: TextStyle(fontSize: 16)),
              Text('Calories: ${_mealPlan.calories}', style: TextStyle(fontSize: 16)),
              Text('Proteins: ${_mealPlan.proteins}', style: TextStyle(fontSize: 16)),
              Text('Carbs: ${_mealPlan.carbs}', style: TextStyle(fontSize: 16)),
              Text('Fats: ${_mealPlan.fats}', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
