import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Shirt',
    //   price: 200,
    //   imageUrl:
    //       'https://i.pinimg.com/236x/b5/ac/eb/b5acebd14663f2b2a6f5d4207b7cd631.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Cosmetics',
    //   price: 700,
    //   imageUrl:
    //       'https://i.pinimg.com/236x/35/4f/c2/354fc2377c5a23870de3ce795dae429d.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Folder',
    //   price: 110,
    //   imageUrl:
    //       'https://i.pinimg.com/236x/9d/34/9a/9d349a65a3a1379f76bb1480be688d50.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Chair',
    //   price: 700,
    //   imageUrl:
    //       'https://i.pinimg.com/236x/58/93/b2/5893b21c598befd70d866b8864fb178c.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Watch',
    //   price: 1000,
    //   imageUrl:
    //       'https://i.pinimg.com/236x/39/4a/71/394a71550a3f21a5a33094be7b72d142.jpg',
    // ),
  ];

  Products(this.token, this.userId, this._items);

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favitem {
    return _items.where((element) => element.isfav).toList();
  }

  Future<void> fetchData([bool isFilter = true]) async {
    String filter = isFilter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://fir-82faf.firebaseio.com/products.json?auth=$token&$filter';
    try {
      print(url);
      final response = await http.get(url);

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData == Null) {
        return;
      }

      url =
          'https://fir-82faf.firebaseio.com/userFavourites/$userId.json?auth=$token';
      final userFav = await http.get(url);

      final userFavData = json.decode(userFav.body);

      List<Product> temp = [];
      responseData.forEach((productID, product) {
        temp.add(
          Product(
            id: productID,
            title: product['title'],
            price: product['price'],
            imageUrl: product['imageURL'],
            isfav:
                userFavData == null ? false : userFavData['productID'] ?? false,
          ),
        );
      });
      _items = temp;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProductItem(Product newProduct) async {
    final url = 'https://fir-82faf.firebaseio.com/products.json?auth=$token';

    try {
      final response = await http.post(url,
          body: json.encode({
            // 'id': '${DateTime.now()}',
            'title': '${newProduct.title}',
            'price': newProduct.price,
            'imageURL': newProduct.imageUrl,
            'creatorId': userId
          }));
      print(json.decode(response.body));
      final Product newProduct1 = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
          isfav: false);
      _items.add(newProduct1);
      print('added');
      notifyListeners();
    } catch (error) {
      print(' error :' + error);
      print('error occured');
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProductItem(
      String productId, Product updatedProduct) async {
    final url =
        'https://fir-82faf.firebaseio.com/products/$productId.json?auth=$token';
    if (productId != null) {
      final prodIndex = _items.indexWhere((pro) => pro.id == productId);
      if (prodIndex >= 0) {
        try {
          await http.patch(url,
              body: json.encode({
                'title': updatedProduct.title,
                'price': updatedProduct.price,
                'imageURL': updatedProduct.imageUrl,
              }));
          _items[prodIndex] = updatedProduct;
          notifyListeners();
        } catch (error) {
          throw error;
        }
      }
    }
  }

  Future<void> removeSingleItem(String productID) async {
    final index = _items.indexWhere((prod) => prod.id == productID);
    final removedData = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final url =
        'https://fir-82faf.firebaseio.com/products/$productID.json?auth=$token';
    try {
      final response = await http.delete(url);
      if (response.statusCode > 400) {
        throw 'error';
      }
    } catch (error) {
      _items.insert(index, removedData);
      notifyListeners();
      throw error;
    }
  }
}
