import 'dart:convert';

class Product {
  final String name;
  final String description;
  final double quantity;
  final double price;
  final String category;
  final List<String> images;
  final String? id;

  // Need to add Rating

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.category,
    required this.images,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'category': category,
      'images': images,
      'id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  //creates a product model
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
