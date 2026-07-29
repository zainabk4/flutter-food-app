import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ModelClass/cart_item.dart';
import '../ModelClass/favorites_service.dart';
import '../ModelClass/food_model.dart';
import '../Widgets/big_text.dart';
import '../Widgets/dimensions.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/popular_app_icon.dart';
import 'cart_page.dart';

class RecommendedFoodPage extends StatefulWidget {
  final FoodItem foodItem;

  const RecommendedFoodPage({super.key, required this.foodItem});

  @override
  State<RecommendedFoodPage> createState() => _RecommendedFoodPageState();
}

class _RecommendedFoodPageState extends State<RecommendedFoodPage> {
  int quantity = 0;
  final CartService _cartService = CartService.instance;
  final FavoritesService _favoritesService = FavoritesService.instance;
  int cartCount = 0;
  bool isFavorite = false;

  // Theme colors
  final Color primary = const Color(0xFF6A4C93);
  final Color secondary = const Color(0xFFC06C84);
  final Color background = const Color(0xFFF8F4E6);
  final Color accent = const Color(0xFFF67280);
  final Color textColor = const Color(0xFF1A1A2E);

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
        backgroundColor: isFavorite ? accent : primary,
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
              backgroundColor: primary,
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
            bgColor: secondary,
            iconColor: Colors.white,
          ),
          if (cartCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: accent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            pinned: true,
            backgroundColor: primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: PopularAppIcon(
                    iconData: Icons.close,
                    bgColor: secondary,
                    iconColor: Colors.white,
                  ),
                ),
                _buildCartIcon(),
              ],
            ),

            // image and header
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                child: Center(
                  child: BigText(
                    size: Dimensions.fontSize26(context),
                    color: textColor,
                    text: widget.foodItem.name,
                  ),
                ),
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  top: 5,
                  bottom: Dimensions.height10(context),
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.foodItem.imagePath,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // description
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.width20(context),
                    right: Dimensions.width20(context),
                    bottom: Dimensions.height20(context),
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: textColor), // #1A1A2E
                    child: ExpandableTextWidget(
                      text: widget.foodItem.description,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1st bottom (quantity + price)
          Container(
            margin: EdgeInsets.only(
              left: Dimensions.width20(context) * 2.5,
              right: Dimensions.width20(context) * 2.5,
              top: Dimensions.height10(context),
              bottom: Dimensions.height10(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Decrease button
                GestureDetector(
                  onTap: () {
                    if (quantity > 0) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  child: PopularAppIcon(
                    iconColor: Colors.white,
                    iconData: Icons.remove,
                    bgColor: primary,
                  ),
                ),

                // Price text
                BigText(
                  color: textColor,
                  text: quantity > 0
                      ? "Rs. ${widget.foodItem.price.toStringAsFixed(0)} x $quantity"
                      : "Rs. ${widget.foodItem.price.toStringAsFixed(0)}",
                  size: Dimensions.fontSize26(context),
                ),

                // Increase button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  child: PopularAppIcon(
                    iconColor: Colors.white,
                    iconData: Icons.add,
                    bgColor: primary,
                  ),
                ),
              ],
            ),
          ),

          // 2nd bottom (Add to Cart)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: secondary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite icon
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isFavorite ? accent : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.white : accent,
                    ),
                  ),
                ),

                // Add to cart button
                GestureDetector(
                  onTap: _addToCart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: quantity > 0 ? primary : primary.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 3),
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
        ],
      ),
    );
  }
}