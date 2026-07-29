import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestPage extends StatelessWidget {
  final FirebaseController controller = Get.put(FirebaseController());

  FirebaseTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_done,
                      size: 48,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Firebase Connected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready to test Firestore operations',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () => controller.addSampleData(),
              icon: const Icon(Icons.add),
              label: const Text('Add Sample Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => controller.getPopularProductList(),
              icon: const Icon(Icons.download),
              label: const Text('Load Popular Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => controller.clearAllData(),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Clear All Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 20),

            // Loading Indicator
            Obx(() => controller.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink()),

            // Products List
            Expanded(
              child: Obx(() {
                if (controller.popularProductList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products loaded',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add sample data or load products to see them here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.popularProductList.length,
                  itemBuilder: (context, index) {
                    final product = controller.popularProductList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.restaurant),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          product.name ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(
                                  ' ${product.rating?.toStringAsFixed(1) ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  product.category ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final RxBool _isLoading = false.obs;
  final RxList<ProductModel> _popularProductList = <ProductModel>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<ProductModel> get popularProductList => _popularProductList;

  // Add sample data method with WORKING IMAGE URLS
  Future<void> addSampleData() async {
    try {
      _isLoading.value = true;

      // Sample food data with PROPER direct image URLs
      List<Map<String, dynamic>> sampleFoods = [
        {
          'name': 'Chicken Biryani',
          'description': 'Aromatic basmati rice with tender chicken pieces and traditional spices',
          'price': 15.99,
          'imageUrl': 'https://images.unsplash.com/photo-1563379091339-03246463d563?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.8,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_001',
          'category': 'Pakistani',
        },
        {
          'name': 'Margherita Pizza',
          'description': 'Classic Italian pizza with fresh tomatoes, mozzarella, and basil',
          'price': 12.99,
          'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.5,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_002',
          'category': 'Italian',
        },
        {
          'name': 'Beef Burger',
          'description': 'Juicy beef patty with lettuce, tomato, cheese and special sauce',
          'price': 9.99,
          'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.3,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_003',
          'category': 'Fast Food',
        },
        {
          'name': 'Chicken Karahi',
          'description': 'Traditional Pakistani curry with tender chicken and aromatic spices',
          'price': 13.99,
          'imageUrl': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.7,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_001',
          'category': 'Pakistani',
        },
        {
          'name': 'Pasta Alfredo',
          'description': 'Creamy fettuccine pasta with parmesan cheese and herbs',
          'price': 11.99,
          'imageUrl': 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.4,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_002',
          'category': 'Italian',
        },
        {
          'name': 'Fish & Chips',
          'description': 'Crispy battered fish with golden fries and tartar sauce',
          'price': 14.99,
          'imageUrl': 'https://images.unsplash.com/photo-1544943910-4c1dc44aab44?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
          'rating': 4.2,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_004',
          'category': 'British',
        }
      ];

      // Clear existing data first
      await clearAllData();

      // Add each food item to Firestore
      for (var foodData in sampleFoods) {
        await _firestore.collection('food_items').add(foodData);
      }

      debugPrint('Sample data added successfully!');
      Get.snackbar(
        'Success',
        'Sample data added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh the list after adding data
      await getPopularProductList();

    } catch (e) {
      debugPrint('Error adding sample data: $e');
      Get.snackbar(
        'Error',
        'Failed to add sample data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Load popular products from Firestore
  Future<void> getPopularProductList() async {
    try {
      _isLoading.value = true;

      QuerySnapshot querySnapshot = await _firestore
          .collection('food_items')
          .where('isPopular', isEqualTo: true)
          .get();

      _popularProductList.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID
        _popularProductList.add(ProductModel.fromJson(data));
      }

      debugPrint('Loaded ${_popularProductList.length} popular products');
      Get.snackbar(
        'Success',
        'Loaded ${_popularProductList.length} popular products',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

    } catch (e) {
      debugPrint('Error loading products: $e');
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Clear all data from Firestore (for testing purposes)
  Future<void> clearAllData() async {
    try {
      _isLoading.value = true;

      QuerySnapshot querySnapshot = await _firestore
          .collection('food_items')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      _popularProductList.clear();

      debugPrint('All data cleared successfully!');
      Get.snackbar(
        'Success',
        'All data cleared successfully!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

    } catch (e) {
      debugPrint('Error clearing data: $e');
      Get.snackbar(
        'Error',
        'Failed to clear data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}

// Product Model class
class ProductModel {
  String? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  double? rating;
  bool? isPopular;
  bool? isFavorite;
  String? restaurantId;
  String? category;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.rating,
    this.isPopular,
    this.isFavorite,
    this.restaurantId,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble(),
      isPopular: json['isPopular'],
      isFavorite: json['isFavorite'],
      restaurantId: json['restaurantId'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'isPopular': isPopular,
      'isFavorite': isFavorite,
      'restaurantId': restaurantId,
      'category': category,
    };
  }
}