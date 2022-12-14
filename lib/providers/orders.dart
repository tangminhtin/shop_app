import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final url = Uri.https(
      'shopapp-caca7-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {
        'auth': authToken,
      },
    );
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((product) => {
                  'id': product.id,
                  'title': product.title,
                  'quantity': product.quantity,
                  'price': product.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
      'shopapp-caca7-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {
        'auth': authToken,
      },
    );
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body);

    if (extractedData == null) {
      _orders = loadedOrders;
      return;
    }
    (extractedData as Map<String, dynamic>).forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (product) => CartItem(
                  id: product['id'],
                  title: product['title'],
                  quantity: product['quantity'],
                  price: product['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
