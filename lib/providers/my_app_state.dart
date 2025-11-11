import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/cat_api_service.dart';
import 'package:flutter_application_1/services/cat_api_service.dart';
import 'package:flutter_application_1/models/cat_details.dart'; //
import 'dart:math';

class MyAppState extends ChangeNotifier {
  List<String> images = [];
  List<String> favorites = [];
  bool isLoading = false;

  final _random = Random();
  final Map<String, CatDetails> _detailsCache = {};

  MyAppState() {
    getImages();
  }

  Future<void> getImages() async {
    isLoading = true;
    notifyListeners();

    try {
      images = await fetchCatImages();
    } catch (e) {
      images = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String url) {
    if (favorites.contains(url)) {
      favorites.remove(url);
    } else {
      favorites.add(url);
    }
    notifyListeners();
  }

  CatDetails getCatDetails(String imageUrl) {
    // Check if we have already generated details for this URL
    if (_detailsCache.containsKey(imageUrl)) {
      return _detailsCache[imageUrl]!;
    } else {
      // If not, generate new fictional details
      final details = _generateFictionalDetails();
      // Store them in the cache
      _detailsCache[imageUrl] = details;
      return details;
    }
  }

  CatDetails _generateFictionalDetails() {
    final names = [
      'Fluffy',
      'Whiskers',
      'Mittens',
      'Shadow',
      'Simba',
      'Leo',
      'Luna',
      'Bella',
    ];
    final owners = [
      'Alice',
      'Bob',
      'Charlie',
      'David',
      'Eve',
      'Frank',
      'Grace',
      'Sr. Gato',
      'Ms. Kitty',
    ];
    final foods = [
      'Tuna',
      'Pollo',
      'Salmon',
      'Catnip',
      'Queso',
      'Leche',
      'Pescado',
      'Carne',
    ];

    return CatDetails(
      name: names[_random.nextInt(names.length)],
      owner: owners[_random.nextInt(owners.length)],
      age: _random.nextInt(15) + 1,
      favoriteFood: foods[_random.nextInt(foods.length)],
    );
  }
}
