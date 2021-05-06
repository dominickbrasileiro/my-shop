import 'package:fshop/models/cart_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> items;
  final DateTime date;

  Order({
    required this.id,
    required this.amount,
    required this.items,
    required this.date,
  });
}
