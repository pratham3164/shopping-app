import 'package:flutter/material.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Shirt',
      price: 200,
      imageUrl:
          'https://i.pinimg.com/236x/b5/ac/eb/b5acebd14663f2b2a6f5d4207b7cd631.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Cosmetics',
      price: 700,
      imageUrl:
          'https://i.pinimg.com/236x/35/4f/c2/354fc2377c5a23870de3ce795dae429d.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Folder',
      price: 110,
      imageUrl:
          'https://i.pinimg.com/236x/9d/34/9a/9d349a65a3a1379f76bb1480be688d50.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Chair',
      price: 700,
      imageUrl:
          'https://i.pinimg.com/236x/58/93/b2/5893b21c598befd70d866b8864fb178c.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Watch',
      price: 1000,
      imageUrl:
          'https://i.pinimg.com/236x/39/4a/71/394a71550a3f21a5a33094be7b72d142.jpg',
    ),
  ];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favitem {
    return _items.where((element) => element.isfav).toList();
  }

  void addProductItem(Product newProduct) {
    newProduct = Product(
        id: DateTime.now().toString(),
        title: newProduct.title,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
        isfav: false);
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void updateProductItem(String productId, Product updatedProduct) {
    if (productId != null) {
      final prodIndex = _items.indexWhere((pro) => pro.id == productId);
      if (prodIndex >= 0) {
        _items[prodIndex] = updatedProduct;
        notifyListeners();
      }
    }
  }

  void removeSingleItem(String productID) {
    final index = _items.indexWhere((prod) => prod.id == productID);
    _items.removeAt(index);
    notifyListeners();
  }
}
