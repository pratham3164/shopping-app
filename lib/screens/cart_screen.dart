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
                          OrderNOwButton(order: order, cart: cart)
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

class OrderNOwButton extends StatefulWidget {
  const OrderNOwButton({
    Key key,
    @required this.order,
    @required this.cart,
  }) : super(key: key);

  // final bool nullAmount;
  final Order order;
  final Cart cart;

  @override
  _OrderNOwButtonState createState() => _OrderNOwButtonState();
}

class _OrderNOwButtonState extends State<OrderNOwButton> {
  bool nullAmount;
  bool showIndicator = false;

  @override
  Widget build(BuildContext context) {
    nullAmount = !(widget.cart.totalamount > 0);
    return Row(
      children: <Widget>[
        if (showIndicator)
          Container(
              height: 25,
              width: 25,
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(6),
              child: CircularProgressIndicator()),
        GestureDetector(
          onTap: nullAmount
              ? null
              : () async {
                  setState(() {
                    showIndicator = true;
                  });
                  print('indicator' + '$showIndicator');
                  try {
                    await widget.order.addOrder(
                        widget.cart.items.values.toList(),
                        widget.cart.totalamount);
                    widget.cart.clear();
                    setState(() {
                      showIndicator = false;
                    });
                  } catch (error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('could\'nt place your order'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
          child: Text('order now',
              style: TextStyle(
                  color:
                      nullAmount ? Colors.grey : Theme.of(context).accentColor,
                  fontSize: 18)),
        ),
      ],
    );
  }
}
