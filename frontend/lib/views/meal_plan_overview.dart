import 'package:flutter/material.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:mealplanningapp/models/mealplan_model.dart';
import 'package:mealplanningapp/views/mealplan_details';
import 'package:mealplanningapp/views/add_meal_screen.dart';

class MealPlanOverview extends StatefulWidget {
  const MealPlanOverview({super.key});

  @override
  _MealPlanOverviewState createState() => _MealPlanOverviewState();
}

class _MealPlanOverviewState extends State<MealPlanOverview> {
  final ApiService _apiService = ApiService();
  List<MealPlan> _mealPlans = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  void _confirmMarkAsConsumed(BuildContext context, MealPlan mealPlan) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text(
              "Are you sure you want to mark ${mealPlan.name} as consumed? It will be added to your nutritional data."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(), // Close the dialog
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _markAsConsumed(
                    context, mealPlan); // Proceed to mark as consumed
              },
            ),
          ],
        );
      },
    );
  }

  void _markAsConsumed(BuildContext context, MealPlan mealPlan) async {
    try {
      await _apiService.markAsConsumed(mealPlan);
      setState(() {
        _mealPlans.removeWhere((plan) => plan.id == mealPlan.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${mealPlan.name} marked as consumed!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark meal as consumed')));
    }
  }

  Future<void> _loadMealPlans() async {
    try {
      var mealPlans = await _apiService.fetchMealPlans(1); // Assume userId is 1
      setState(() {
        _mealPlans = mealPlans;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Meal Plans'),
      actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddMealPlan()),
              );
            },
          ),
        ],
    ),
    body: ListView.builder(
      itemCount: _mealPlans.length,
      itemBuilder: (context, index) {
        MealPlan mealPlan = _mealPlans[index];
                return CheckboxListTile(
                  title: Text(mealPlan.name),
                  subtitle: Text(mealPlan.type),
                  value: false,
                  onChanged: (bool? value) {
                    if (value == true) {
                      _confirmMarkAsConsumed(context, _mealPlans[index]);
                    }
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MealPlanDetails(mealPlan: mealPlan)));
                    },
                  ),
                );
              },
            ),
    );
  }
}
