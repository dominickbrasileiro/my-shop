import 'package:flutter/material.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/widgets/app_drawer.dart';
import 'package:fshop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.itemCount,
        itemBuilder: (ctx, i) => OrderItemWidget(
          order: orders[i],
        ),
      ),
    );
  }
}
