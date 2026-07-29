import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ModelClass/food_model.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  static FavoritesService get instance => _instance;

  FavoritesService._internal() {
    _loadFavorites(); // Load saved favorites on startup
  }

  final List<FoodItem> _favoriteItems = [];

  List<FoodItem> get favoriteItems => List.unmodifiable(_favoriteItems);

  int get favoriteCount => _favoriteItems.length;

  bool isFavorite(FoodItem item) {
    return _favoriteItems.any((favItem) => favItem.name == item.name);
  }

  Future<void> toggleFavorite(FoodItem item) async {
    if (isFavorite(item)) {
      _favoriteItems.removeWhere((favItem) => favItem.name == item.name);
    } else {
      _favoriteItems.add(item);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(FoodItem item) async {
    _favoriteItems.removeWhere((favItem) => favItem.name == item.name);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favoriteItems.clear();
    await _saveFavorites();
    notifyListeners();
  }

  /// Save favorites to local storage
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = _favoriteItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('favorites', favList);
  }

  /// Load favorites from local storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];

    _favoriteItems
      ..clear()
      ..addAll(favList.map((jsonStr) => FoodItem.fromJson(jsonDecode(jsonStr))));

    notifyListeners();
  }
}
