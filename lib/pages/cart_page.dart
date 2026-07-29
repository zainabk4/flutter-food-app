import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ModelClass/cart_item.dart';


class CartService extends ChangeNotifier {
  static const String _cartKey = 'cart_items';
  List<CartItem> _items = [];
  static CartService? _instance;

  static CartService get instance {
    _instance ??= CartService._internal();
    return _instance!;
  }

  CartService._internal();

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData != null && cartData.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(cartData);
        _items = jsonList.map((item) => CartItem.fromJson(item)).toList();
      } else {
        _items = [];
      }

      print('Loaded cart items: ${_items.length}');
      notifyListeners();
    } catch (e) {
      print('Error loading cart items: $e');
      _items = [];
      notifyListeners();
    }
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _items.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, json.encode(jsonList));
      print('Saved cart items: ${_items.length}');
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      final existingIndex = _items.indexWhere((cartItem) => cartItem.id == item.id);

      if (existingIndex != -1) {
        _items[existingIndex].quantity += item.quantity;
      } else {
        _items.add(item);
      }

      await _saveCartItems();
      print('Added to cart: ${item.name}, Total items: ${_items.length}');
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      _items.removeWhere((item) => item.id == itemId);
      await _saveCartItems();
      print('Removed from cart: $itemId, Remaining items: ${_items.length}');
      notifyListeners();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      final itemIndex = _items.indexWhere((item) => item.id == itemId);

      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          _items.removeAt(itemIndex);
        } else {
          _items[itemIndex].quantity = newQuantity;
        }
        await _saveCartItems();
        print('Updated quantity for $itemId: $newQuantity');
        notifyListeners();
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      _items.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      print('Cart cleared');
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  // Static methods for backward compatibility
  static Future<List<CartItem>> getCartItems() async {
    await instance.loadCartItems();
    return instance.items;
  }

  static Future<void> saveCartItems(List<CartItem> items) async {
    instance._items = items;
    await instance._saveCartItems();
    instance.notifyListeners();
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFFF8F4E6),
      child: const Icon(Icons.restaurant, color: Color(0xFF6A4C93), size: 30),
    );
  }

}

class _CartPageState extends State<CartPage> with AutomaticKeepAliveClientMixin {
  final CartService _cartService = CartService.instance;
  bool isLoading = true;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadCartItems() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    await _cartService.loadCartItems();

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    await _cartService.updateQuantity(itemId, newQuantity);
  }

  Future<void> _removeItem(String itemId) async {
    await _cartService.removeFromCart(itemId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Color(0xFF6A4C93),
        ),
      );
    }
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF8F4E6),
          title: Text('Checkout', style: TextStyle(color: Color(0xFF1A1A2E))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Items: ${_cartService.itemCount}',
                  style: TextStyle(color: Color(0xFF1A1A2E))),
              Text('Total Amount: Rs.${_cartService.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Proceed to payment?', style: TextStyle(color: Color(0xFF1A1A2E))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF1A1A2E).withOpacity(0.7))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processCheckout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A4C93),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _processCheckout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF8F4E6),
          title: Text('Order Placed!', style: TextStyle(color: Color(0xFF1A1A2E))),
          content: Text('Thank you for your order. You will receive a confirmation shortly.',
              style: TextStyle(color: Color(0xFF1A1A2E))),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cartService.clearCart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A4C93),
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F4E6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F4E6),
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF6A4C93),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_cartService.itemCount} items',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                child: CircularProgressIndicator(color: Color(0xFF6A4C93))
            )
                : _cartService.items.isEmpty
                ? _buildEmptyCart()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartService.items.length,
              itemBuilder: (context, index) {
                final item = _cartService.items[index];
                return _buildCartItem(item);
              },
            ),
          ),
          if (_cartService.items.isNotEmpty) _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100,
              color: Color(0xFF1A1A2E).withOpacity(0.3)),
          const SizedBox(height: 24),
          Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600
              )),
          const SizedBox(height: 12),
          Text('Add some delicious items to get started!',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1A2E).withOpacity(0.7)
              )),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.restaurant_menu),
            label: Text('Browse Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A4C93),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image with fallback (supports asset + network)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF8F4E6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.image.isNotEmpty
                    ? (item.isNetworkImage
                    ? Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackIcon(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6A4C93),
                        strokeWidth: 2,
                      ),
                    );
                  },
                )
                    : Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                ))
                    : _buildFallbackIcon(),
              ),
            ),
            const SizedBox(width: 12),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs.${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A4C93),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Total: Rs.${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1A1A2E).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => item.quantity > 1
                          ? _updateQuantity(item.id, item.quantity - 1)
                          : _removeItem(item.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F4E6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Color(0xFF6A4C93).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          item.quantity > 1
                              ? Icons.remove
                              : Icons.delete_outline,
                          size: 16,
                          color: item.quantity > 1
                              ? Color(0xFF1A1A2E)
                              : Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _updateQuantity(item.id, item.quantity + 1),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(0xFF6A4C93),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable fallback icon if image fails
  Widget _buildFallbackIcon() {
    return Container(
      color: Color(0xFFF8F4E6),
      child: const Icon(
        Icons.restaurant,
        color: Color(0xFF6A4C93),
        size: 30,
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A1A2E).withOpacity(0.6)
                    ),
                  ),
                  Text(
                    'Rs.${_cartService.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E)
                    ),
                  ),
                  Text(
                    '${_cartService.itemCount} items',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6A4C93)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _showCheckoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A4C93),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}