import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/manage_product_screen.dart';

import '../screens/orders_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello !'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Shop'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/')),
          Divider(),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Orders'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(OrderScreen.routeName)),
          Divider(),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Manage Products'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(ManageProductScreen.routeName)),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
