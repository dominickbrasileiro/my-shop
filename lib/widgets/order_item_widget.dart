import 'package:flutter/material.dart';
import 'package:fshop/models/order.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  OrderItemWidget({
    required this.order,
  });

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat.yMMMEd().format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: widget.order.items.length * 25 + 10,
              child: ListView(
                children: widget.order.items.map((item) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.quantity}x \$${item.price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
