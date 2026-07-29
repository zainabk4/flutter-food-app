import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> searchResults = [];
  bool isSearching = false;

  // Sample food data
  final List<FoodItem> allFoodItems = [
    FoodItem(
      id: '1',
      name: 'Korean Side Dish',
      description: 'Authentic Korean side dish with vegetables',
      image: 'assets/images/food1.jpg',
      price: 12.99,
      rating: 4.5,
      category: 'Korean',
    ),
    FoodItem(
      id: '2',
      name: 'Nutritious Breakfast',
      description: 'Healthy breakfast with chinese characteristics',
      image: 'assets/images/food10.jpg',
      price: 8.99,
      rating: 4.2,
      category: 'Breakfast',
    ),
    FoodItem(
      id: '3',
      name: 'Italian Pizza',
      description: 'Fresh Italian pizza with mozzarella',
      image: 'assets/images/food2.jpg',
      price: 15.99,
      rating: 4.8,
      category: 'Italian',
    ),
    FoodItem(
      id: '4',
      name: 'Chicken Burger',
      description: 'Juicy chicken burger with fries',
      image: 'assets/images/food3.jpg',
      price: 11.99,
      rating: 4.3,
      category: 'Fast Food',
    ),
    FoodItem(
      id: '5',
      name: 'Sushi Platter',
      description: 'Fresh sushi with wasabi and ginger',
      image: 'assets/images/food4.jpg',
      price: 22.99,
      rating: 4.7,
      category: 'Japanese',
    ),
    FoodItem(
      id: '6',
      name: 'Pasta Carbonara',
      description: 'Creamy pasta with bacon and cheese',
      image: 'assets/images/food5.jpg',
      price: 13.99,
      rating: 4.4,
      category: 'Italian',
    ),
    FoodItem(
      id: '7',
      name: 'Thai Curry',
      description: 'Spicy Thai curry with vegetables',
      image: 'assets/images/food6.jpg',
      price: 14.99,
      rating: 4.6,
      category: 'Thai',
    ),
    FoodItem(
      id: '8',
      name: 'Mexican Tacos',
      description: 'Authentic mexican tacos with salsa',
      image: 'assets/images/food7.jpg',
      price: 9.99,
      rating: 4.1,
      category: 'Mexican',
    ),
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      searchResults = allFoodItems
          .where((food) =>
      food.name.toLowerCase().contains(query.toLowerCase()) ||
          food.description.toLowerCase().contains(query.toLowerCase()) ||
          food.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E6), // Royal Plum background
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)), // Royal Plum text
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F4E6), // Royal Plum background
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: Color(0xFF1A1A2E)), // Royal Plum text
                        decoration: InputDecoration(
                          hintText: 'Search for food...',
                          hintStyle: TextStyle(color: Color(0xFF1A1A2E).withOpacity(0.6)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF6A4C93)), // Royal Plum primary
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                            child: Icon(Icons.clear, color: Color(0xFF1A1A2E).withOpacity(0.6)),
                          )
                              : null,
                        ),
                        onChanged: _performSearch,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildSearchSuggestions()
                  : searchResults.isEmpty && isSearching
                  ? _buildNoResults()
                  : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final food = searchResults[index];
                  return _buildFoodItem(food);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final popularSearches = ['Pizza', 'Burger', 'Sushi', 'Pasta', 'Korean', 'Breakfast'];

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E), // Royal Plum text
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF6A4C93).withOpacity(0.1), // Royal Plum primary
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF6A4C93).withOpacity(0.3)),
                  ),
                  child: Text(
                    search,
                    style: TextStyle(
                      color: Color(0xFF6A4C93), // Royal Plum primary
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Color(0xFF1A1A2E).withOpacity(0.4)),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E), // Royal Plum text
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1A2E).withOpacity(0.7), // Royal Plum text
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A4C93).withOpacity(0.1), // Royal Plum shadow
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${food.name} details'),
              backgroundColor: Color(0xFF6A4C93), // Royal Plum primary
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(food.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E), // Royal Plum text
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      food.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A1A2E).withOpacity(0.7), // Royal Plum text
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\${food.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A4C93), // Royal Plum primary
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Color(0xFFF67280), size: 16), // Royal Plum accent
                            SizedBox(width: 4),
                            Text(
                              food.rating.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1A1A2E).withOpacity(0.7), // Royal Plum text
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final String category;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });
}