import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  bool isfav;

  Product(
      {this.id,
      @required this.title,
      @required this.price,
      @required this.imageUrl,
      this.isfav = false});

  Future<void> toggleIsFavStatus(String token, String userId) async {
    final url =
        'https://fir-82faf.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    final bool oldValue = isfav;
    print('inside toggle');
    print(url);
    isfav = !isfav;
    notifyListeners();
    try {
      await http.put(url,
          body: json.encode(
            isfav,
          ));
    } catch (error) {
      isfav = oldValue;
      print('failed');
      notifyListeners();
    }
  }
}
