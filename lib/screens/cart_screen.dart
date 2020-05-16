import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
// import 'package:shopping_app/widgets/custom_drawer.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Order>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Chip(
                            label: Text('\$${cart.totalamount}'),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              order.addOrder(
                                  cart.items.values.toList(), cart.totalamount);
                              cart.clear();
                            },
                            child: Text('order now',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 18)),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.count,
                  itemBuilder: (context, i) => CartItem(
                        id: cart.items.values.toList()[i].id,
                        title: cart.items.values.toList()[i].title,
                        quantity: cart.items.values.toList()[i].quantity,
                        price: cart.items.values.toList()[i].price,
                      )))
        ],
      ),
    );
  }
}
