import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/productdetails';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context).item.firstWhere((pro) => pro.id == id);
    return Scaffold(
        appBar: AppBar(title: Text(product.title)),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 0.5 *
                  (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              )),
          SizedBox(height: 10),
          Text(
            '\$${product.price}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
          )
        ])));
  }
}
