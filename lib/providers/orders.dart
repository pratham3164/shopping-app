import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  const OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.date});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cart, double amount) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: amount,
            products: cart,
            date: DateTime.now()));
    notifyListeners();
  }
}
