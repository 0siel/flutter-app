import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/cat_api_service.dart'; // <-- UPDATE THIS

class MyAppState extends ChangeNotifier {
  List<String> images = [];
  List<String> favorites = [];
  bool isLoading = false;

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
}
