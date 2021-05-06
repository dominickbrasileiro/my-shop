import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:fshop/widgets/app_drawer.dart';
import 'package:fshop/widgets/manage_product_item_widget.dart';
import 'package:provider/provider.dart';

class ManageProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.products;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsProvider.itemCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ManageProductItemWidget(
                  product: products[i],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
