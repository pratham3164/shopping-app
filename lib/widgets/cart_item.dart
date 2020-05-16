import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem(
      {Key key,
      @required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: Text('Do you want to remove this item from cart?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                ));
      },
      onDismissed: (_) => cart.removeItemfromCart(id),
      background: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: Theme.of(context).primaryColor,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: FittedBox(
                      child: Text('\$$price'),
                    ))),
            title: Text(title),
            subtitle: Text('total: \$${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
