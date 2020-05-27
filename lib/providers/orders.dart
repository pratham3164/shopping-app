import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final String token;
  final String userID;

  Order(this.token, this.userID, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchData() async {
    final url =
        'https://fir-82faf.firebaseio.com/$userID/orders.json?auth=$token';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      if (responseData == null) {
        print('no data');
        return;
      }
      List<OrderItem> _dummyorders = [];
      OrderItem dd;
      responseData.forEach((orderID, orderItem) {
        print('in ');
        dd = OrderItem(
          id: orderID,
          date: DateTime.parse(orderItem['date']),
          products: (orderItem['products'] as List<dynamic>)
              .map((product) => CartItem(
                    id: product['id'],
                    title: product['title'],
                    quantity: product['quantity'],
                    price: product['price'],
                  ))
              .toList(),
          amount: orderItem['amount'],
        );
        _dummyorders.add(dd);
      });
      _orders = _dummyorders;
      print(_orders);
      notifyListeners();
    } catch (error) {
      print('coudnt fetch');
    }
  }

  Future<void> addOrder(List<CartItem> cart, double amount) async {
    final url =
        'https://fir-82faf.firebaseio.com/$userID/orders.json?auth=$token';
    try {
      await http.post(url,
          body: json.encode({
            'amount': amount,
            'date': DateTime.now().toIso8601String(),
            'products': cart
                .map((product) => {
                      'id': product.id,
                      'title': product.title,
                      'price': product.price,
                      'quantity': product.quantity
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: amount,
              products: cart,
              date: DateTime.now()));
      notifyListeners();
    } catch (error) {
      print('order cancelled');
      throw error;
    }
  }
}
