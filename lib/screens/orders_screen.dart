import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart' show Order;
import 'package:shopping_app/widgets/custom_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    print('fetching data');
    Provider.of<Order>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(title: const Text('Your Orders')),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, i) => OrderItem(orderData.orders[i])),
    );
  }
}
