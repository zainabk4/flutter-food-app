import 'package:flutter/material.dart';
import '../ModelClass/favorites_service.dart';
import '../ModelClass/food_model.dart';
import '../Widgets/big_text.dart';
import '../Widgets/small_text.dart';
import '../Widgets/icon_text_widget.dart';
import '../Widgets/popular_app_icon.dart';
import '../pages/popular_food_page.dart';
import '../pages/recommended_food_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService.instance;

  // Theme colors
  final Color primary = const Color(0xFF6A4C93);
  final Color secondary = const Color(0xFFC06C84);
  final Color background = const Color(0xFFF8F4E6);
  final Color accent = const Color(0xFFF67280);
  final Color textColor = const Color(0xFF1A1A2E);

  @override
  void initState() {
    super.initState();
    _favoritesService.addListener(_updateUI);
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        title: BigText(
          text: "My Favorites",
          color: Colors.white,
          size: 24,
        ),
        centerTitle: true,
        actions: [
          if (_favoritesService.favoriteItems.isNotEmpty)
            Container(
              margin: EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  _showClearAllDialog();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.clear_all, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _favoritesService.favoriteItems.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: primary,
            ),
          ),
          SizedBox(height: 30),
          BigText(
            text: "No Favorites Yet",
            color: textColor,
            size: 24,
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: SmallText(
              text: "Start adding your favorite dishes by tapping the heart icon on any food item",
              color: textColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: BigText(
                text: "Browse Food",
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              BigText(
                text: "${_favoritesService.favoriteCount} Items",
                color: textColor,
                size: 18,
              ),
              Spacer(),
              SmallText(
                text: "Swipe to remove",
                color: textColor.withOpacity(0.6),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _favoritesService.favoriteItems.length,
            itemBuilder: (context, index) {
              final foodItem = _favoritesService.favoriteItems[index];
              return Dismissible(
                key: Key(foodItem.name),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _favoritesService.removeFavorite(foodItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${foodItem.name} removed from favorites'),
                      backgroundColor: accent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to appropriate page based on category or index
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PopularFoodPage(
                            foodItem: foodItem,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image container
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(foodItem.imagePath),
                              ),
                            ),
                          ),
                          // Text container
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: foodItem.name,
                                    color: textColor,
                                    size: 16,
                                  ),
                                  SizedBox(height: 8),
                                  SmallText(
                                    text: foodItem.category,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: accent, size: 16),
                                      SizedBox(width: 5),
                                      SmallText(
                                        text: foodItem.quality,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(Icons.location_on, color: primary, size: 16),
                                      SizedBox(width: 5),
                                      SmallText(
                                        text: foodItem.distance,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  BigText(
                                    text: "Rs. ${foodItem.price.toStringAsFixed(0)}",
                                    color: primary,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: BigText(
            text: "Clear All Favorites?",
            color: textColor,
            size: 18,
          ),
          content: SmallText(
            text: "This will remove all items from your favorites list. This action cannot be undone.",
            color: textColor.withOpacity(0.7),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: textColor),
              ),
            ),
            TextButton(
              onPressed: () {
                _favoritesService.clearFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: accent,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                "Clear All",
                style: TextStyle(color: accent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}