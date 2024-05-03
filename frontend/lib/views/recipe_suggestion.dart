import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> items = [
    'Tomatoes',
    'Chicken Breast',
    'Basil',
    'Olive Oil',
    'Pasta',
    'Mushrooms'
  ]; // Placeholder for shopping list items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            trailing: IconButton(
              icon: Icon(Icons.check_box_outline_blank),
              onPressed: () {
                setState(() {
                  items.removeAt(index); // Removes the item from the list when checked
                });
              },
            ),
          );
        },
      ),
    );
  }
}
