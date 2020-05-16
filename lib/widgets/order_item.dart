import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shopping_app/providers/orders.dart' as oi;

class OrderItem extends StatefulWidget {
  final oi.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isexpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(
        children: [
          ListTile(
              title: Text('\$${widget.order.amount}'),
              trailing: IconButton(
                  icon:
                      Icon(isexpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isexpanded = !isexpanded;
                    });
                  })),
          if (isexpanded)
            Container(
                height: min(widget.order.products.length * 20.0 + 20, 200),
                padding: const EdgeInsets.only(bottom: 3),
                child: ListView(
                    children: widget.order.products
                        .map((cartItem) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(cartItem.title,
                                        style: TextStyle(fontSize: 18)),
                                    Text(
                                        '${cartItem.quantity} * \$${cartItem.price}')
                                  ]),
                            ))
                        .toList()))
        ],
      ),
    );
  }
}
