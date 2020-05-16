import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  bool isfav;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.imageUrl,
      this.isfav = false});

  void toggleIsFavStatus() {
    isfav = !isfav;
    notifyListeners();
  }
}
