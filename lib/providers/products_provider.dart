import 'package:flutter/material.dart';
import 'package:fshop/data/dummy_data.dart';
import 'package:fshop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get products => [..._items];

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void toggleFavoriteById(int id) {
    final product = _items.firstWhere((product) => product.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
