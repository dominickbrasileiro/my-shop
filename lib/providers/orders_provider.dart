import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fshop/models/cart_item.dart';
import 'package:fshop/models/order.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get orders => [..._items];

  int get itemCount => _items.length;

  void addOrder(List<CartItem> items, double amount) {
    _items.add(Order(
      id: _items.length + 1,
      amount: amount,
      items: items,
      date: DateTime.now(),
    ));

    notifyListeners();
  }
}
