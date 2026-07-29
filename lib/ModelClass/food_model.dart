class FoodItem {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String category;
  final String distance;
  final String time;
  final String quality;

  FoodItem({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.distance,
    required this.time,
    required this.quality,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'price': price,
    'category': category,
    'distance': distance,
    'time': time,
    'quality': quality,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    imagePath: json['imagePath'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    category: json['category'] ?? '',
    distance: json['distance'] ?? '',
    time: json['time'] ?? '',
    quality: json['quality'] ?? '',
  );
}
