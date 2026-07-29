// PopularFoodPage.dart
import 'package:flutter/material.dart';

import '../ModelClass/cart_item.dart';
import '../ModelClass/favorites_service.dart';
import '../ModelClass/food_model.dart';
import '../Widgets/big_text.dart';
import '../Widgets/dimensions.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/icon_text_widget.dart';
import '../Widgets/popular_app_icon.dart';
import '../Widgets/small_text.dart';
import 'app_column.dart';
import 'cart_page.dart'; // Import your cart page


class PopularFoodPage extends StatefulWidget {
  final FoodItem foodItem;

  const PopularFoodPage({super.key, required this.foodItem});

  @override
  State<PopularFoodPage> createState() => _PopularFoodPageState();
}

class _PopularFoodPageState extends State<PopularFoodPage> {
  int quantity = 0;
  final CartService _cartService = CartService.instance;
  final FavoritesService _favoritesService = FavoritesService.instance;
  int cartCount = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _updateCartCount();
    _updateFavoriteStatus();
    _cartService.addListener(_updateCartCount);
    _favoritesService.addListener(_updateFavoriteStatus);
  }

  @override
  void dispose() {
    _cartService.removeListener(_updateCartCount);
    _favoritesService.removeListener(_updateFavoriteStatus);
    super.dispose();
  }

  void _updateCartCount() {
    if (mounted) {
      setState(() {
        cartCount = _cartService.itemCount;
      });
    }
  }

  void _updateFavoriteStatus() {
    if (mounted) {
      setState(() {
        isFavorite = _favoritesService.isFavorite(widget.foodItem);
      });
    }
  }

  void _toggleFavorite() {
    _favoritesService.toggleFavorite(widget.foodItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.foodItem.name} added to favorites!'
              : '${widget.foodItem.name} removed from favorites!',
        ),
        backgroundColor: isFavorite ? const Color(0xFFF67280) : const Color(0xFF6A4C93),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addToCart() async {
    if (quantity > 0) {
      try {
        final cartItem = CartItem(
          id: widget.foodItem.name.toString(),
          name: widget.foodItem.name,
          image: widget.foodItem.imagePath, // You might need to convert this to a URL
          price: widget.foodItem.price.toDouble(),
          quantity: quantity,
        );

        await _cartService.addToCart(cartItem);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.foodItem.name} (x$quantity) added to cart!'),
              backgroundColor: const Color(0xFF6A4C93),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: 'View Cart',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
            ),
          );

          // Reset quantity after adding to cart
          setState(() {
            quantity = 0;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding to cart: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select quantity first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildCartIcon() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
      child: Stack(
        children: [
          PopularAppIcon(
            iconData: Icons.shopping_cart_outlined,
            iconColor: Colors.white,
            bgColor: const Color(0xFFF67280), // Coral pink
          ),
          if (cartCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFC06C84), // Rose pink
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$cartCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: PopularAppIcon(
        iconData: isFavorite ? Icons.favorite : Icons.favorite_border,
        iconColor: Colors.white,
        bgColor: isFavorite ? const Color(0xFFF67280) : const Color(0xFFC06C84), // Changes color based on favorite status
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E6), // Warm cream background
      body: Stack(
        children: [

          // image positioned
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularImageSize(context),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(widget.foodItem.imagePath),
                ),
              ),
            ),
          ),

          // icons positioned
          Positioned(
            top: 45,
            left: Dimensions.width20(context),
            right: Dimensions.height20(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: PopularAppIcon(
                    iconData: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    bgColor: const Color(0xFFC06C84), // Rose pink
                  ),
                ),
                Row(
                  children: [
                    _buildFavoriteIcon(),
                    SizedBox(width: 10),
                    _buildCartIcon(),
                  ],
                ),
              ],
            ),
          ),

          // image round border
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularImageSize(context)-20,
            child: Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20(context),
                  right: Dimensions.width20(context) - 2.8 // Fix overflow by reducing right padding by 2.8 pixels
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Color(0xFFF8F4E6), // Warm cream
              ),

              // body of item detail
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height10(context),),
                  AppColumn(
                    text: widget.foodItem.name,
                    foodItem: widget.foodItem, // Pass the foodItem to AppColumn
                  ),
                  SizedBox(height: Dimensions.height20(context),),
                  BigText(
                    color: const Color(0xFF1A1A2E), // Dark navy
                    text: "Introduce",
                  ),
                  SizedBox(height: Dimensions.height20(context),),
                  // expandable text
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableTextWidget(text: widget.foodItem.description),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),

      // cart bottom
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.only(top: 30, bottom: 30, right: 20, left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A4C93).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF8F4E6), // Warm cream
                border: Border.all(
                  color: const Color(0xFFC06C84).withOpacity(0.3), // Rose pink border
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A4C93).withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 0) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.remove,
                      color: Color(0xFF6A4C93), // Deep purple
                    ),
                  ),
                  const SizedBox(width: 12),
                  BigText(
                    color: const Color(0xFF1A1A2E), // Dark navy
                    text: quantity.toString(),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF6A4C93), // Deep purple
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _addToCart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: quantity > 0
                      ? const Color(0xFF6A4C93) // Deep purple
                      : const Color(0xFF6A4C93).withOpacity(0.6), // Disabled state
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A4C93).withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: BigText(
                  color: Colors.white,
                  text: quantity > 0
                      ? "Rs. ${(widget.foodItem.price * quantity).toStringAsFixed(0)}  Add to cart"
                      : "Select quantity",
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}