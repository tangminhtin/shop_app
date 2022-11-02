import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('All'),
              ),
            ],
            onSelected: (FilterOptions filterOption) {
              setState(() {
                if (filterOption == FilterOptions.favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Badge(
                color: Colors.red,
                value: cart.cartCount.toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(showFavorites: _showFavorites),
    );
  }
}
