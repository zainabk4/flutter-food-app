import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ModelClass/food_product.dart';

class PopularProductController extends GetxController {
  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list for popular products
  RxList<FoodProduct> _popularProductList = <FoodProduct>[].obs;
  RxBool _isLoading = false.obs;

  // Getters
  List<FoodProduct> get popularProductList => _popularProductList;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getPopularProductList();
  }

  // Get popular products from Firebase Firestore
  Future<void> getPopularProductList() async {
    try {
      _isLoading.value = true;

      QuerySnapshot querySnapshot = await _firestore
          .collection('food_items')
          .where('isPopular', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      _popularProductList.clear();

      for (var doc in querySnapshot.docs) {
        FoodProduct product = FoodProduct.fromFirestore(doc);
        _popularProductList.add(product);
      }
    } catch (e) {
      print('Error fetching popular products: $e');
      Get.snackbar('Error', 'Failed to load popular products');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add product to favorites (example Firebase operation)
  Future<void> toggleFavorite(String productId) async {
    try {
      await _firestore
          .collection('food_items')
          .doc(productId)
          .update({'isFavorite': FieldValue.increment(1)});

      // Update local list
      int index = _popularProductList.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _popularProductList[index].isFavorite =
        !_popularProductList[index].isFavorite;
        _popularProductList.refresh();
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }


  Future<void> addSampleData() async {
    try {
      _isLoading.value = true;

      // Sample food data
      List<Map<String, dynamic>> sampleFoods = [
        {
          'name': 'Chicken Biryani',
          'description': 'Aromatic basmati rice with tender chicken pieces and traditional spices',
          'price': 15.99,
          'imageUrl': 'https://unsplash.com/photos/a-bowl-of-food-on-a-plate-with-spices-TNNZ8KNPfbY',
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
          'imageUrl': 'https://unsplash.com/photos/a-pepperoni-pizza-cut-into-slices-on-a-wooden-table-mIESW2fwM3s',
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
          'imageUrl': 'https://unsplash.com/photos/burger-with-lettuce-and-tomatoes-sc5sTPMrVfk',
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
          'imageUrl': 'https://unsplash.com/photos/a-pan-filled-with-meat-and-vegetables-on-top-of-a-stove-jjoyL1hk1Vo',
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
          'imageUrl': 'https://unsplash.com/photos/a-plate-of-food-on-a-wooden-table-Jrvcg9My0B4',
          'rating': 4.4,
          'isPopular': true,
          'isFavorite': false,
          'restaurantId': 'rest_002',
          'category': 'Italian',
        }
      ];

      // Add each food item to Firestore
      for (var foodData in sampleFoods) {
        await _firestore.collection('food_items').add(foodData);
      }

      print('Sample data added successfully!');

      // Refresh the list after adding data
      await getPopularProductList();
    } catch (e) {
      print('Error adding sample data: $e');
      Get.snackbar('Error', 'Failed to add sample data: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}