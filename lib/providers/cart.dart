import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _carts = {};

  Map<String, CartItem> get carts {
    return {..._carts};
  }

  int get cartCount {
    return _carts.length;
  }

  double get totalAmount {
    double total = 0.0;
    _carts.forEach((key, cart) {
      total += cart.quantity * cart.price;
    });
    return total;
  }

  void addCartItem(
    String productId,
    double price,
    String title,
  ) {
    if (_carts.containsKey(productId)) {
      _carts.update(
        productId,
        (existingCartItem) {
          return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price,
          );
        },
      );
    } else {
      _carts.putIfAbsent(
        productId,
        () {
          return CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price,
          );
        },
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _carts.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _carts = {};
    notifyListeners();
  }

  void removeSingleCartItem(String productId) {
    if (!_carts.containsKey(productId)) {
      return;
    }
    if (_carts[productId]!.quantity > 1) {
      _carts.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _carts.remove(productId);
    }
    notifyListeners();
  }
}
