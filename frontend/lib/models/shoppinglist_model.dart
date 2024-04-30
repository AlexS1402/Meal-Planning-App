import 'shoppinglistitem_model.dart';  // Assuming you have a model for individual items

class ShoppingListModel {
  final String id;
  final DateTime dateCreated;
  final List<ShoppingListItemModel> items; // List of items in the shopping list
  bool completed;

  ShoppingListModel({
    required this.id,
    required this.dateCreated,
    required this.items,
    this.completed = false,
  });

// Factory constructor to create a ShoppingListModel from a map
  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
    id: map['id'],
    dateCreated: DateTime.parse(map['dateCreated']),
    items: (map['items'] as List<dynamic>).map((item) => ShoppingListItemModel.fromMap(item)).toList(),
    completed: map['completed'],
    );
  }

// Method to convert ShoppingListModel to a map
  Map<String, dynamic> toMap() {
    return {
    'id': id,
    'dateCreated': dateCreated.toIso8601String(),
    'items': items.map((item) => item.toMap()).toList(),
    'completed': completed,
    };
  }
}