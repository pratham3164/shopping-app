import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_product_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details.dart';
import './screens/product_overview.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.pink,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: ,
        routes: {
          '/': (context) => ProductOverview(),
          ProductDetails.routeName: (context) => ProductDetails(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          ManageProductScreen.routeName: (context) => ManageProductScreen(),
          EditProductScreeen.routeName: (context) => EditProductScreeen()
        },
      ),
    );
  }
}
