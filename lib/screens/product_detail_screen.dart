import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)?.settings.arguments as String;
    final Product product =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price}',
            style: const TextStyle(
              fontSize: 25,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(product.description),
        ],
      ),
    );
  }
}
