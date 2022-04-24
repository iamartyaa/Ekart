import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite() async {
    final oldStatus = isFavourite;

    isFavourite = !isFavourite;

    final url = Uri.https(
        'shop-app-29cf9-default-rtdb.firebaseio.com', '/products/$id.json');
    try
    {
      await http.patch(url,
          body: jsonEncode({
            'isFavourite': isFavourite,
          }));
      notifyListeners();
    }catch(error){
      isFavourite=oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
