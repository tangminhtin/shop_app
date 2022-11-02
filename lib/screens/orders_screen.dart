import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orders orderProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          return OrderItem(
            order: orderProvider.orders[index],
          );
        },
      ),
    );
  }
}
