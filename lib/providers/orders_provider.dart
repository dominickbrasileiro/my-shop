import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fshop/models/cart_item.dart';
import 'package:fshop/models/order.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> items, double amount) {
    _orders.add(Order(
      id: _orders.length + 1,
      amount: amount,
      items: items,
      date: DateTime.now(),
    ));

    notifyListeners();
  }
}
