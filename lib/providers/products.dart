import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(this.authToken, this.userId, this._products);

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) async {
    try {
      final url = Uri.https(
        'shopapp-caca7-default-rtdb.firebaseio.com',
        '/products.json',
        {
          'auth': authToken,
        },
      );
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'shopapp-caca7-default-rtdb.firebaseio.com',
      '/products/$id.json',
      {
        'auth': authToken,
      },
    );
    final int existingProductIndex =
        _products.indexWhere((product) => product.id == id);
    Product? existingProduct = _products[existingProductIndex];
    _products.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _products.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.https(
        'shopapp-caca7-default-rtdb.firebaseio.com',
        '/products/$id.json',
        {
          'auth': authToken,
        },
      );
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }),
      );
      _products[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Update product failed!');
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final url = Uri.https(
        'shopapp-caca7-default-rtdb.firebaseio.com',
        '/products.json',
        {
          'auth': authToken,
          'orderBy': "\"creatorId\"",
          'equalTo': filterByUser ? '"$userId"' : '',
        },
      );

      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }

      final urlFavorites = Uri.https(
        'shopapp-caca7-default-rtdb.firebaseio.com',
        '/userFavorites/$userId.json',
        {
          'auth': authToken,
        },
      );

      final favoriteResponse = await http.get(urlFavorites);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      (extractedData as Map<String, dynamic>).forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ),
        );
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
