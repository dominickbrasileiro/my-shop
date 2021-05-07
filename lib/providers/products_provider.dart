import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/core/exceptions/http_exception.dart';
import 'package:fshop/models/partial_product.dart';
import 'package:fshop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final _baseUrl = 'https://my-shop-f01af-default-rtdb.firebaseio.com';

  List<Product> _items = [];

  List<Product> get products => [..._items];

  int get itemCount => _items.length;

  Future<void> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/products.json');
    final response = await http.get(url);

    Map<String, dynamic>? data = json.decode(response.body);

    if (data != null) {
      _items.clear();

      data.forEach((id, productData) {
        _items.add(Product(
          id: id,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });

      notifyListeners();
    }
  }

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> addProduct(PartialProduct partialProduct) async {
    final url = Uri.parse('$_baseUrl/products.json');
    final response = await http.post(
      url,
      body: json.encode({
        'title': partialProduct.title,
        'description': partialProduct.description,
        'price': partialProduct.price,
        'imageUrl': partialProduct.imageUrl,
        'isFavorite': partialProduct.isFavorite,
      }),
    );

    final id = json.decode(response.body)['name'];

    _items.add(Product(
      id: id,
      title: partialProduct.title,
      price: partialProduct.price,
      description: partialProduct.description,
      imageUrl: partialProduct.imageUrl,
      isFavorite: partialProduct.isFavorite,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final productIndex =
        _items.indexWhere((_product) => _product.id == product.id);

    if (productIndex < 0) {
      return;
    }

    final url = Uri.parse('$_baseUrl/products/${product.id}.json');
    final response = await http.patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    if (response.statusCode >= 400) {
      throw new HttpException();
    }

    _items[productIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      final product = _items[index];

      _items.removeWhere((product) => product.id == id);
      notifyListeners();

      final url = Uri.parse('$_baseUrl/products/${product.id}.json');
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw HttpException();
      }
    }
  }

  Future<void> toggleFavoriteById(String id) async {
    final product = _items.firstWhere((product) => product.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/products/${product.id}.json');
    final response = await http.patch(
      url,
      body: json.encode({
        'isFavorite': product.isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      product.isFavorite = !product.isFavorite;
      notifyListeners();

      throw HttpException();
    }
  }
}
