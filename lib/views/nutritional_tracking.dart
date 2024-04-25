import 'package:flutter/material.dart';

class NutritionalTracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutritional Tracking'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Daily Intake', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text('Calories: 1200 kcal'),
              subtitle: Text('60% of daily goal'),
            ),
            ListTile(
              title: Text('Protein: 50 g'),
              subtitle: Text('80% of daily goal'),
            ),
            ListTile(
              title: Text('Carbohydrates: 150 g'),
              subtitle: Text('50% of daily goal'),
            ),
          ],
        ),
      ),
    );
  }
}
