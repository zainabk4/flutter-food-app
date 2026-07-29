import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ModelClass/favorites_service.dart';
import '../Widgets/big_text.dart';
import '../Widgets/small_text.dart';
import '../pages/search_page.dart';
import '../pages/favorites_page.dart';
import 'food_page_body.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  String selectedCity = "Faisalabad";
  final FavoritesService _favoritesService = FavoritesService.instance;
  int favoriteCount = 0;

  final List<String> cities = [
    "Faisalabad",
    "Lahore",
    "Karachi",
    "Islamabad",
    "Rawalpindi",
  ];

  @override
  void initState() {
    super.initState();
    _updateFavoriteCount();
    _favoritesService.addListener(_updateFavoriteCount);
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_updateFavoriteCount);
    super.dispose();
  }

  void _updateFavoriteCount() {
    if (mounted) {
      setState(() {
        favoriteCount = _favoritesService.favoriteCount;
      });
    }
  }

  void _showCitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F4E6), // Royal Plum background
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select City",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E), // Royal Plum text
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Color(0xFF1A1A2E)),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Color(0xFF6A4C93).withOpacity(0.3)),
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      title: Text(city, style: TextStyle(color: Color(0xFF1A1A2E))),
                      trailing: selectedCity == city
                          ? Icon(Icons.check, color: Color(0xFF6A4C93)) // Royal Plum primary
                          : null,
                      onTap: () {
                        setState(() {
                          selectedCity = city;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(),
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return GestureDetector(
      onTap: _openFavorites,
      child: Stack(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFF67280), // Royal Plum accent
            ),
            child: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
          if (favoriteCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Color(0xFF6A4C93), // Royal Plum primary
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$favoriteCount',
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
      backgroundColor: Color(0xFFF8F4E6), // Royal Plum background
      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 45, bottom: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(text: "Pakistan", color: Color(0xFF6A4C93)), // Royal Plum primary
                      GestureDetector(
                        onTap: _showCitySelector,
                        child: Row(
                          children: [
                            SmallText(text: selectedCity, color: Color(0xFF1A1A2E).withOpacity(0.7)),
                            Icon(Icons.arrow_drop_down, color: Color(0xFF1A1A2E).withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildFavoriteIcon(),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: _openSearch,
                        child: Container(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.search, color: Colors.white),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF6A4C93), // Royal Plum primary
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(),
            ),
          ),
        ],
      ),
    );
  }
}