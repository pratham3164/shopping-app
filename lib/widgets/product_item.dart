import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: product.id),
        child: GridTile(
            child: Hero(
                tag: product.imageUrl,
                child: Image.network(product.imageUrl, fit: BoxFit.cover)),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(product.title),
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () =>
                      product.toggleIsFavStatus(auth.idToken, auth.userId),
                  icon: Icon(
                    product.isfav ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Item added to the cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )),
      ),
    );
  }
}
