import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ModelClass/food_model.dart'; // Import your existing FoodItem class
import 'recommended_food_page.dart'; // Import your RecommendedFoodPage

class FoodCategory {
  final String id;
  final String name;
  final String image;
  final List<FoodItem> foodItems;

  FoodCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.foodItems,
  });
}

class CategoryService {
  static List<FoodCategory> getAllCategories() {
    return [
      FoodCategory(
        id: '1',
        name: 'Pizza',
        image: 'assets/images/pizza_category.jpg',
        foodItems: [
          FoodItem(
            name: 'Margherita Pizza',
            description: 'Classic Italian pizza with fresh mozzarella, tomato sauce, and basil leaves. Made with authentic Italian ingredients and baked in a wood-fired oven for the perfect crispy crust.',
            imagePath: 'assets/images/margherita_pizza.jpg',
            price: 1299.0,
            category: 'Pizza',
            distance: '2.5km',
            time: '25-30 min',
            quality: '4.5★',
          ),
          FoodItem(
            name: 'Pepperoni Pizza',
            description: 'Delicious pizza topped with premium pepperoni slices and mozzarella cheese. A classic American favorite that never goes out of style.',
            imagePath: 'assets/images/pepperoni_pizza.jpg',
            price: 1599.0,
            category: 'Pizza',
            distance: '2.5km',
            time: '25-30 min',
            quality: '4.7★',
          ),
          FoodItem(
            name: 'BBQ Chicken Pizza',
            description: 'Smoky BBQ chicken with red onions, bell peppers, and tangy BBQ sauce on a crispy pizza base.',
            imagePath: 'assets/images/bbq_chicken_pizza.jpg',
            price: 1899.0,
            category: 'Pizza',
            distance: '2.5km',
            time: '30-35 min',
            quality: '4.6★',
          ),
        ],
      ),
      FoodCategory(
        id: '2',
        name: 'Burger',
        image: 'assets/images/burger_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Classic Beef Burger',
            description: 'Juicy beef patty grilled to perfection, topped with fresh lettuce, tomato, onions, and our special house sauce. Served with crispy fries.',
            imagePath: 'assets/images/beef_burger.jpg',
            price: 999.0,
            category: 'Burger',
            distance: '1.8km',
            time: '15-20 min',
            quality: '4.4★',
          ),
          FoodItem(
            name: 'Chicken Deluxe Burger',
            description: 'Tender grilled chicken breast with avocado, bacon, lettuce, and mayo in a toasted brioche bun.',
            imagePath: 'assets/images/chicken_burger.jpg',
            price: 1199.0,
            category: 'Burger',
            distance: '1.8km',
            time: '15-20 min',
            quality: '4.6★',
          ),
          FoodItem(
            name: 'Double Cheese Burger',
            description: 'Double beef patties with double cheese, crispy bacon, pickles, and our signature sauce.',
            imagePath: 'assets/images/double_cheese.jpg',
            price: 1399.0,
            category: 'Burger',
            distance: '1.8km',
            time: '20-25 min',
            quality: '4.8★',
          ),
        ],
      ),
      FoodCategory(
        id: '3',
        name: 'Sushi',
        image: 'assets/images/sushi_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Salmon Roll',
            description: 'Fresh Atlantic salmon with avocado, cucumber, and sushi rice, wrapped in premium nori seaweed.',
            imagePath: 'assets/images/salmon_roll.jpg',
            price: 1499.0,
            category: 'Sushi',
            distance: '3.2km',
            time: '35-40 min',
            quality: '4.8★',
          ),
          FoodItem(
            name: 'California Roll',
            description: 'Classic California roll with fresh crab meat, avocado, and cucumber, topped with sesame seeds.',
            imagePath: 'assets/images/california_sushi.jpg',
            price: 1299.0,
            category: 'Sushi',
            distance: '3.2km',
            time: '35-40 min',
            quality: '4.5★',
          ),
          FoodItem(
            name: 'Tuna Nigiri',
            description: 'Premium fresh tuna sashimi over perfectly seasoned sushi rice, served with wasabi and pickled ginger.',
            imagePath: 'assets/images/tuna_nigiri.jpg',
            price: 1699.0,
            category: 'Sushi',
            distance: '3.2km',
            time: '35-40 min',
            quality: '4.9★',
          ),
        ],
      ),
      FoodCategory(
        id: '4',
        name: 'Pasta',
        image: 'assets/images/pasta_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Spaghetti Carbonara',
            description: 'Classic Italian pasta with eggs, parmesan cheese, pancetta, and black pepper. Rich and creamy without using cream.',
            imagePath: 'assets/images/carbonara.jpg',
            price: 1399.0,
            category: 'Pasta',
            distance: '2.1km',
            time: '20-25 min',
            quality: '4.7★',
          ),
          FoodItem(
            name: 'Penne Arrabbiata',
            description: 'Spicy tomato sauce with garlic, red chili flakes, and fresh herbs tossed with al dente penne pasta.',
            imagePath: 'assets/images/arrabbiata.jpg',
            price: 1199.0,
            category: 'Pasta',
            distance: '2.1km',
            time: '15-20 min',
            quality: '4.4★',
          ),
          FoodItem(
            name: 'Fettuccine Alfredo',
            description: 'Rich and creamy white sauce with parmesan cheese, butter, and garlic over fresh fettuccine pasta.',
            imagePath: 'assets/images/fettuccine.jpg',
            price: 1499.0,
            category: 'Pasta',
            distance: '2.1km',
            time: '20-25 min',
            quality: '4.6★',
          ),
        ],
      ),
      FoodCategory(
        id: '5',
        name: 'Korean',
        image: 'assets/images/korean_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Bibimbap',
            description: 'Traditional Korean mixed rice bowl with seasoned vegetables, marinated beef, and a fried egg, served with gochujang sauce.',
            imagePath: 'assets/images/bibimbap.jpg',
            price: 1699.0,
            category: 'Korean',
            distance: '4.1km',
            time: '40-45 min',
            quality: '4.8★',
          ),
          FoodItem(
            name: 'Korean BBQ',
            description: 'Grilled marinated beef bulgogi served with steamed rice, kimchi, and traditional side dishes (banchan).',
            imagePath: 'assets/images/korean_bbq.jpg',
            price: 2299.0,
            category: 'Korean',
            distance: '4.1km',
            time: '45-50 min',
            quality: '4.9★',
          ),
          FoodItem(
            name: 'Kimchi Fried Rice',
            description: 'Spicy fried rice made with aged kimchi, beef, and topped with a fried egg and green onions.',
            imagePath: 'assets/images/kimchi_rice.jpg',
            price: 1399.0,
            category: 'Korean',
            distance: '4.1km',
            time: '35-40 min',
            quality: '4.5★',
          ),
        ],
      ),
      FoodCategory(
        id: '6',
        name: 'Breakfast',
        image: 'assets/images/breakfast_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Classic Pancakes',
            description: 'Fluffy buttermilk pancakes served with butter, maple syrup, and fresh berries. A perfect breakfast treat.',
            imagePath: 'assets/images/pancakes.jpg',
            price: 899.0,
            category: 'Breakfast',
            distance: '1.2km',
            time: '10-15 min',
            quality: '4.6★',
          ),
          FoodItem(
            name: 'Eggs Benedict',
            description: 'Poached eggs on toasted English muffins with Canadian bacon, topped with rich hollandaise sauce.',
            imagePath: 'assets/images/eggs_benedict.jpg',
            price: 1299.0,
            category: 'Breakfast',
            distance: '1.2km',
            time: '15-20 min',
            quality: '4.7★',
          ),
          FoodItem(
            name: 'Avocado Toast',
            description: 'Toasted sourdough bread topped with mashed avocado, cherry tomatoes, and a perfectly poached egg.',
            imagePath: 'assets/images/avocado_toast.jpg',
            price: 799.0,
            category: 'Breakfast',
            distance: '1.2km',
            time: '10-15 min',
            quality: '4.4★',
          ),
        ],
      ),
      FoodCategory(
        id: '7',
        name: 'Desi',
        image: 'assets/images/desi_categories.jpg',
        foodItems: [
          FoodItem(
            name: 'Chicken Biryani',
            description: 'Aromatic basmati rice layered with tender chicken pieces, cooked with traditional spices, saffron, and fried onions.',
            imagePath: 'assets/images/chicken_biryani.jpg',
            price: 1599.0,
            category: 'Desi',
            distance: '2.8km',
            time: '30-35 min',
            quality: '4.9★',
          ),
          FoodItem(
            name: 'Butter Chicken',
            description: 'Creamy tomato-based curry with tender chicken pieces, rich spices, and a touch of cream. Served with naan or rice.',
            imagePath: 'assets/images/butter_chicken.jpg',
            price: 1399.0,
            category: 'Desi',
            distance: '2.8km',
            time: '25-30 min',
            quality: '4.8★',
          ),
          FoodItem(
            name: 'Karahi Gosht',
            description: 'Traditional Pakistani mutton curry cooked in a karahi with tomatoes, green chilies, and aromatic spices.',
            imagePath: 'assets/images/karahi_gosht.jpg',
            price: 1799.0,
            category: 'Desi',
            distance: '2.8km',
            time: '35-40 min',
            quality: '4.7★',
          ),
        ],
      ),
    ];
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<FoodCategory> categories = [];
  bool isLoading = true;

  // Royal Plum Theme Colors
  final Color primary = const Color(0xFF6A4C93);
  final Color secondary = const Color(0xFFC06C84);
  final Color background = const Color(0xFFF8F4E6);
  final Color accent = const Color(0xFFF67280);
  final Color textColor = const Color(0xFF1A1A2E);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final loadedCategories = CategoryService.getAllCategories();
    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
  }

  Future<void> _onCategoryTap(FoodCategory category) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodItemsPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Categories Grid
            Expanded(
              child: _buildCategoriesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: primary,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.80,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(FoodCategory category) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: secondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onCategoryTap(category),
        borderRadius: BorderRadius.circular(18),
        splashColor: primary.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.asset(
                    category.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: background,
                        child: Icon(
                          Icons.restaurant,
                          color: primary,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Category Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Side - Texts
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${category.foodItems.length} items available',
                            style: TextStyle(
                              fontSize: 12,
                              color: primary.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Right Side - Arrow Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: primary,
                        ),
                      ),
                    ],
                  ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Food Items Page - Shows food items when category is clicked
class FoodItemsPage extends StatelessWidget {
  final FoodCategory category;

  const FoodItemsPage({super.key, required this.category});

  // Royal Plum Theme Colors
  final Color primary = const Color(0xFF6A4C93);
  final Color secondary = const Color(0xFFC06C84);
  final Color background = const Color(0xFFF8F4E6);
  final Color accent = const Color(0xFFF67280);
  final Color textColor = const Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: category.foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = category.foodItems[index];
          return _buildFoodItemCard(context, foodItem);
        },
      ),
    );
  }

  Widget _buildFoodItemCard(BuildContext context, FoodItem foodItem) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: secondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedFoodPage(foodItem: foodItem),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: primary.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    foodItem.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: background,
                        child: Icon(
                          Icons.fastfood,
                          color: primary,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Food Details
            Expanded( // 👈 Use Expanded instead of Flexible
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder( // 👈 lets us adapt inside tight space
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(), // no actual scroll, just avoids overflow
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 spaces price at bottom
                          children: [
                            // Top section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodItem.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: accent, size: 14),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        foodItem.quality,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textColor.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Bottom section - Price
                            Text(
                              'Rs. ${foodItem.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),





          ],
        ),
      ),
    );
  }
}
