import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/core/app_constants.dart';
import 'package:fshop/models/cart_item.dart';
import 'package:fshop/models/order.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<Order> items = [];
  late String? token;

  OrdersProvider({
    required this.items,
    this.token,
  });

  List<Order> get orders => [...items];

  int get itemCount => items.length;

  Future<void> fetchOrders() async {
    final url =
        Uri.parse('${AppConstants.BASE_API_URL}/orders.json?auth=$token');
    final response = await http.get(url);

    Map<String, dynamic>? data = json.decode(response.body);

    if (data != null) {
      items.clear();

      data.forEach((id, orderData) {
        items.insert(
            0,
            Order(
              id: id,
              amount: orderData['amount'],
              date: DateTime.parse(orderData['date']),
              items: (orderData['items'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      productId: item['productId'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                    ),
                  )
                  .toList(),
            ));
      });

      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    final date = DateTime.now();

    final url =
        Uri.parse('${AppConstants.BASE_API_URL}/orders.json?auth=$token');
    final response = await http.post(
      url,
      body: json.encode({
        'amount': amount,
        'date': date.toIso8601String(),
        'items': cartItems
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    final id = json.decode(response.body)['name'];

    items.insert(
        0,
        Order(
          id: id,
          amount: amount,
          items: cartItems,
          date: date,
        ));

    notifyListeners();
  }
}
