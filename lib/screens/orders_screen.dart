import 'package:flutter/material.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/widgets/app_drawer.dart';
import 'package:fshop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _fetchOrders() async {
    await Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchOrders,
              child: ListView.builder(
                itemCount: ordersProvider.itemCount,
                itemBuilder: (ctx, i) => OrderItemWidget(
                  order: orders[i],
                ),
              ),
            ),
    );
  }
}
