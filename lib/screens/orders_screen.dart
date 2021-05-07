import 'package:flutter/material.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/widgets/app_drawer.dart';
import 'package:fshop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  Future<void> _fetchOrders(ctx) async {
    await Provider.of<OrdersProvider>(ctx, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: FutureBuilder(
        future: _fetchOrders(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child:
                  Text('An unexpected error ocurred. Please try again later.'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _fetchOrders(context),
              child: Consumer<OrdersProvider>(
                builder: (ctx, ordersProvider, child) => ListView.builder(
                  itemCount: ordersProvider.itemCount,
                  itemBuilder: (ctx, i) => OrderItemWidget(
                    order: ordersProvider.orders[i],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
