// Create this file: controllers/assets_upload_controller.dart
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class AssetsUploadController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxBool _isUploading = false.obs;
  RxDouble _uploadProgress = 0.0.obs;
  RxString _currentItem = ''.obs;

  // Getters
  bool get isUploading => _isUploading.value;
  double get uploadProgress => _uploadProgress.value;
  String get currentItem => _currentItem.value;

  List<Map<String, dynamic>> foodItems = [
    // 1 food
    {
      'name': 'Korean Side',
      'description': 'Delicious Korean cuisine with traditional flavors',
      'price': 18.99,
      'category': 'Korean',
      'restaurantId': 'rest_001',
      'rating': 4.5,
      'isPopular': true,
      'assetPath': 'assets/images/food1.jpg', // Update with your path
    },
    // 2 food
    {
      'name': 'Nutritious Fruit Meal',
      'description': 'Healthy fruit meal with Chinese characteristics',
      'price': 12.99,
      'category': 'Healthy',
      'restaurantId': 'rest_002',
      'rating': 4.3,
      'isPopular': true,
      'assetPath': 'assets/images/food10.jpg', // Update with your path
    },
    // 3 food
    {
      'name': 'Sweet Dessert',
      'description': 'Delightful sweet dessert to end your meal',
      'price': 8.99,
      'category': 'Dessert',
      'restaurantId': 'rest_003',
      'rating': 4.7,
      'isPopular': true,
      'assetPath': 'assets/images/food6.jpg', // Update with your path
    },
    // 4 food
    {
      'name': 'Chicken Biryani',
      'description': 'Aromatic basmati rice with tender chicken pieces',
      'price': 16.99,
      'category': 'Pakistani',
      'restaurantId': 'rest_004',
      'rating': 4.8,
      'isPopular': true,
      'assetPath': 'assets/images/food12.jpg', // Update with your path
    },
    // 5 food
    {
      'name': 'Butter Chicken',
      'description': 'Creamy Butter Chicken with fresh naan',
      'price': 14.99,
      'category': 'Indian',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food9.jpg', // Update with your path
    },
    // 6 food
    {
      'name': 'Fried Chicken & Rice',
      'description': 'Crispy fried chicken with boiled rice',
      'price': 14.99,
      'category': 'Japanese',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food7.jpg', // Update with your path
    },
    // 7 food
    {
      'name': 'Pizza Margherita',
      'description': 'Classic Italian pizza with fresh mozzarella',
      'price': 14.99,
      'category': 'Italian',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food8.jpg', // Update with your path
    },
    // 8 food
    {
      'name': 'Soup Dumplings',
      'description': 'Dumplings with chilli oil spinkled with sesame seeds',
      'price': 14.99,
      'category': 'Chinese',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food4.jpg', // Update with your path
    },
    // 9 food
    {
      'name': 'Spicy Ramen',
      'description': 'Delicious Spicy Ramen with fried egg',
      'price': 14.99,
      'category': 'Korean',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food3.jpg', // Update with your path
    },
    // 10 food
    {
      'name': 'Masala Dosa',
      'description': 'Traditional Indian dish with spices',
      'price': 14.99,
      'category': 'Indian',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food2.jpg', // Update with your path
    },
    // 11 food
    {
      'name': 'Alfredo Fettucine Pasta',
      'description': 'Creamy Alfredo Fettucine Pasta with chicken & parmesan cheese',
      'price': 14.99,
      'category': 'Italian',
      'restaurantId': 'rest_005',
      'rating': 4.4,
      'isPopular': true,
      'assetPath': 'assets/images/food11.jpg', // Update with your path
    },
  ];

  // Upload all food items from assets to Firebase
  Future<void> uploadAllFoodItems() async {
    try {
      _isUploading.value = true;
      _uploadProgress.value = 0.0;

      for (int i = 0; i < foodItems.length; i++) {
        var item = foodItems[i];
        _currentItem.value = item['name'];
        _uploadProgress.value = i / foodItems.length;

        // Upload image from assets to Firebase Storage
        String imageUrl = await _uploadAssetImage(item['assetPath'], item['name']);

        // Save food data to Firestore
        Map<String, dynamic> foodData = {
          'name': item['name'],
          'description': item['description'],
          'price': item['price'],
          'category': item['category'],
          'restaurantId': item['restaurantId'],
          'imageUrl': imageUrl,
          'rating': item['rating'],
          'isPopular': item['isPopular'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('food_items').add(foodData);

        print('✅ Uploaded: ${item['name']}');
      }

      _uploadProgress.value = 1.0;
      _currentItem.value = 'Complete!';

      Get.snackbar(
        'Success!',
        '${foodItems.length} food items uploaded successfully!',
        duration: Duration(seconds: 3),
      );

    } catch (e) {
      print('❌ Error uploading food items: $e');
      Get.snackbar('Error', 'Failed to upload: $e');
    } finally {
      _isUploading.value = false;
      _uploadProgress.value = 0.0;
      _currentItem.value = '';
    }
  }

  // Upload single asset image to Firebase Storage
  Future<String> _uploadAssetImage(String assetPath, String fileName) async {
    try {
      // Load image from assets
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      // Create unique filename
      String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName.jpg';

      // Upload to Firebase Storage
      Reference ref = _storage.ref().child('food_images/$uniqueFileName');
      UploadTask uploadTask = ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;

    } catch (e) {
      print('Error uploading asset image: $e');
      throw e;
    }
  }

  // Add single food item
  Future<void> addSingleFoodItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required String restaurantId,
    required String assetPath,
    double rating = 4.0,
    bool isPopular = false,
  }) async {
    try {
      _isUploading.value = true;
      _currentItem.value = name;

      // Upload image
      String imageUrl = await _uploadAssetImage(assetPath, name);

      // Save to Firestore
      Map<String, dynamic> foodData = {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'restaurantId': restaurantId,
        'imageUrl': imageUrl,
        'rating': rating,
        'isPopular': isPopular,
        'isFavorite': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('food_items').add(foodData);

      Get.snackbar('Success', '$name uploaded successfully!');

    } catch (e) {
      print('Error adding single food item: $e');
      Get.snackbar('Error', 'Failed to upload $name: $e');
    } finally {
      _isUploading.value = false;
      _currentItem.value = '';
    }
  }

  // Upload restaurant data
  Future<void> uploadRestaurants() async {
    List<Map<String, dynamic>> restaurants = [
      {
        'id': 'rest_001',
        'name': 'Golden Dragon Chinese',
        'cuisine': 'Chinese',
        'rating': 4.5,
        'deliveryTime': '30-40 min',
        'deliveryFee': 2.99,
        'isActive': true,
      },
      {
        'id': 'rest_002',
        'name': 'Healthy Bites',
        'cuisine': 'Healthy',
        'rating': 4.3,
        'deliveryTime': '25-35 min',
        'deliveryFee': 1.99,
        'isActive': true,
      },
      {
        'id': 'rest_003',
        'name': 'Sweet Dreams',
        'cuisine': 'Desserts',
        'rating': 4.7,
        'deliveryTime': '20-30 min',
        'deliveryFee': 2.49,
        'isActive': true,
      },
    ];

    try {
      for (var restaurant in restaurants) {
        await _firestore.collection('restaurants').doc(restaurant['id']).set({
          'name': restaurant['name'],
          'cuisine': restaurant['cuisine'],
          'rating': restaurant['rating'],
          'deliveryTime': restaurant['deliveryTime'],
          'deliveryFee': restaurant['deliveryFee'],
          'isActive': restaurant['isActive'],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar('Success', 'Restaurants uploaded successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload restaurants: $e');
    }
  }
}