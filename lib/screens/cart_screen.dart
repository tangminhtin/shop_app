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
                  OrderButton(cartProvider: cartProvider),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: (widget.cartProvider.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cartProvider.carts.values.toList(),
                      widget.cartProvider.totalAmount,
                    );

                    setState(() {
                      _isLoading = false;
                    });
                    widget.cartProvider.clearCart();
                  },
            child: Text(
              'Order now'.toUpperCase(),
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
  }
}
