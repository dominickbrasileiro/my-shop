import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/data/dummy_data.dart';
import 'package:fshop/models/partial_product.dart';
import 'package:fshop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get products => [..._items];

  int get itemCount => _items.length;

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> addProduct(PartialProduct partialProduct) async {
    final url = Uri.parse(
        'https://my-shop-f01af-default-rtdb.firebaseio.com/products.json');

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

  void updateProduct(Product product) {
    final productIndex =
        _items.indexWhere((_product) => _product.id == product.id);

    if (productIndex < 0) {
      return;
    }

    _items[productIndex] = product;
    notifyListeners();
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      _items.removeWhere((product) => product.id == id);
      notifyListeners();
    }
  }

  void toggleFavoriteById(String id) {
    final product = _items.firstWhere((product) => product.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
