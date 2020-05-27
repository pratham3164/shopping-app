import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';

import '../providers/products.dart';
import './edit_product_screen.dart';
import '../widgets/custom_drawer.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = '/manageProductScreen';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreeen.routeName);
              })
        ],
      ),
      body: ListView.builder(
        itemCount: products.item.length,
        itemBuilder: (context, i) =>
            ManageProductItem(products: products.item[i]),
      ),
    );
  }
}

class ManageProductItem extends StatelessWidget {
  const ManageProductItem({
    Key key,
    @required this.products,
  }) : super(key: key);

  final Product products;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(products.imageUrl),
          ),
          title: Text(products.title),
          trailing: Container(
            width: MediaQuery.of(context).size.width * 0.28,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        EditProductScreeen.routeName,
                        arguments: products.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                  onPressed: () async {
                    try {
                      await product.removeSingleItem(products.id);
                    } catch (error) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Couldnt delete!')));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
