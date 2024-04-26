import 'package:flutter/material.dart';

class MealPlanOverview extends StatelessWidget {
  const MealPlanOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 7, // One for each day of the week
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Day ${index + 1}'),
              subtitle: Text('Meal details here...'),
              onTap: () {
                // Placeholder for tapping on a day to view/edit meals
              },
            );
          },
        ),
      ),
    );
  }
}
