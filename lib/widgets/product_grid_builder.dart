import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductGridBuilder extends StatelessWidget {
  const ProductGridBuilder({
    Key key,
    @required this.showOption,
  }) : super(key: key);

  final bool showOption;

  @override
  Widget build(BuildContext context) {
    final List<Product> products = showOption
        ? Provider.of<Products>(context).favitem
        : Provider.of<Products>(context).item;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
            value: products[i], child: ProductItem()));
  }
}
