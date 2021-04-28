import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/models/product.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;

  ProductItemWidget({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAILS,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () => productsProvider.toggleFavoriteById(product.id),
            color: Theme.of(context).accentColor,
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
