import "package:cloud_firestore/cloud_firestore.dart";

class FoodProduct {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  double rating;
  bool isPopular;
  bool isFavorite;
  String restaurantId;
  String category;

  FoodProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.isPopular = false,
    this.isFavorite = false,
    required this.restaurantId,
    required this.category,
  });

  // Convert Firestore document to FoodProduct
  factory FoodProduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FoodProduct(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      isPopular: data['isPopular'] ?? false,
      isFavorite: data['isFavorite'] ?? false,
      restaurantId: data['restaurantId'] ?? '',
      category: data['category'] ?? '',
    );
  }

  // Convert FoodProduct to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'isPopular': isPopular,
      'isFavorite': isFavorite,
      'restaurantId': restaurantId,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}