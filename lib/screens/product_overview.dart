import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/badge.dart';
import 'package:shopping_app/widgets/custom_drawer.dart';

import '../widgets/product_grid_builder.dart';

enum FilterOptions { favs, all }

class ProductOverview extends StatefulWidget {
  static const routeName = '/productOverview';
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool showOption = false;
  bool isLoading = true;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchData()
        .then((value) => setState(() {
              isLoading = false;
              print(isLoading);
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.count.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )),
          PopupMenuButton(
              onSelected: (FilterOptions _selectedOption) {
                setState(() {
                  if (_selectedOption == FilterOptions.favs) {
                    showOption = true;
                  } else {
                    showOption = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: const Text('only favs'),
                        value: FilterOptions.favs),
                    PopupMenuItem(
                        child: const Text('all'), value: FilterOptions.all),
                  ])
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGridBuilder(
              showOption: showOption,
            ),
    );
  }
}
