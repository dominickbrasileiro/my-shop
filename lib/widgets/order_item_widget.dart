import 'package:flutter/material.dart';
import 'package:fshop/models/order.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  final Order order;

  OrderItemWidget({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(
          DateFormat.yMMMEd().format(order.date),
        ),
        trailing: IconButton(
          icon: Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}
