import 'package:flutter/material.dart';
import 'package:fshop/models/cart_item.dart';
import 'package:fshop/models/product.dart';

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingProduct) => CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          quantity: existingProduct.quantity + 1,
          price: existingProduct.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }
}