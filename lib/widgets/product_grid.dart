import 'package:flutter/material.dart';
import 'package:fshop/models/product.dart';
import 'package:fshop/widgets/product_grid_item_widget.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  ProductGrid({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ProductGridItemWidget(product: products[i]),
    );
  }
}
