import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:mealplanningapp/services/user_service.dart';

class NutritionalTracking extends StatefulWidget {
  const NutritionalTracking({Key? key}) : super(key: key);

  @override
  _NutritionalTrackingState createState() => _NutritionalTrackingState();
}

class _NutritionalTrackingState extends State<NutritionalTracking> {
  String selectedNutrient = 'calories'; // default selection
  List<charts.Series<NutrientData, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    int userId = await UserService.getUserId();
    final response = await http.get(Uri.parse(
        'http://192.168.1.215:3001/nutrition-chart/$userId/$selectedNutrient'));
    final data = jsonDecode(response.body) as List;
    final DateFormat formatter = DateFormat('MMM dd');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        seriesList = [
          charts.Series<NutrientData, String>(
            id: 'Nutrition',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (NutrientData nutrients, _) =>
                formatter.format(nutrients.date),
            measureFn: (NutrientData nutrients, _) => nutrients.amount,
            data: data
                .map((item) => NutrientData(
                    DateTime.parse(item['dateConsumed']),
                    item[selectedNutrient]))
                .toList(),
          )
        ];
      });
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Chart'),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: selectedNutrient,
            onChanged: (String? newValue) {
              setState(() {
                selectedNutrient = newValue!;
                fetchData(); // reload data when nutrient changes
              });
            },
            items: <String>['calories', 'proteins', 'carbs', 'fats']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: charts.BarChart(
              seriesList,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}

class NutrientData {
  final DateTime date;
  final int amount;

  NutrientData(this.date, this.amount);
}
