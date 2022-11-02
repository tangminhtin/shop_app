import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cartProvider = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cartProvider.carts.values.toList(),
                        cartProvider.totalAmount,
                      );
                      cartProvider.clearCart();
                    },
                    child: Text(
                      'Order now'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.carts.length,
              itemBuilder: (context, index) {
                return CartItem(
                  id: cartProvider.carts.values.toList()[index].id,
                  productId: cartProvider.carts.keys.toList()[index],
                  title: cartProvider.carts.values.toList()[index].title,
                  quantity: cartProvider.carts.values.toList()[index].quantity,
                  price: cartProvider.carts.values.toList()[index].price,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
