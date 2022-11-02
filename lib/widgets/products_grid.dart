import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid({
    super.key,
    required this.showFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final Products productProvider = Provider.of<Products>(context);
    final List<Product> products = showFavorites
        ? productProvider.favoriteProducts
        : productProvider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
