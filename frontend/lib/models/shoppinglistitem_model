class ShoppingListItemModel {
  final String id;
  final String name;
  final int quantity;
  bool purchased;

  ShoppingListItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.purchased = false,
  });

  factory ShoppingListItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListItemModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      purchased: map['purchased'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'purchased': purchased,
    };
  }
}