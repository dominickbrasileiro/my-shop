import 'package:flutter/material.dart';
import 'package:fshop/data/dummy_data.dart';
import 'package:fshop/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get products => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
