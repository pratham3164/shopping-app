import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = Map();

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get count {
    return _items == null ? 0 : _items.length;
  }

  double get totalamount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItemfromCart(String id) {
    print(id);
    _items.removeWhere((key, cartItem) => cartItem.id == id);
    notifyListeners();
  }

  void addItem(String productid, String title, double price) {
    print('added');

    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (existingData) => CartItem(
              id: existingData.id,
              title: existingData.title,
              price: existingData.price,
              quantity: existingData.quantity + 1));
    } else {
      _items.putIfAbsent(
          productid,
          () =>
              CartItem(id: productid, title: title, price: price, quantity: 1));
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                price: existingCartItem.price,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
