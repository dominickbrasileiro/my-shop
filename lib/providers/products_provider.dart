import 'package:flutter/material.dart';
import 'package:fshop/data/dummy_data.dart';
import 'package:fshop/models/partial_product.dart';
import 'package:fshop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get products => [..._items];

  int get itemCount => _items.length;

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(PartialProduct partialProduct) {
    final product = Product(
      id: _items.length + 1,
      title: partialProduct.title,
      price: partialProduct.price,
      description: partialProduct.description,
      imageUrl: partialProduct.imageUrl,
      isFavorite: partialProduct.isFavorite,
    );

    _items.add(product);

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

  void toggleFavoriteById(int id) {
    final product = _items.firstWhere((product) => product.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }
}
