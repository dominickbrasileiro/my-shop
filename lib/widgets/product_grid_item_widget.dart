import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/core/exceptions/http_exception.dart';
import 'package:fshop/models/product.dart';
import 'package:fshop/providers/cart_provider.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductGridItemWidget extends StatelessWidget {
  final Product product;

  ProductGridItemWidget({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

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
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () async {
              try {
                await productsProvider.toggleFavoriteById(product.id);
              } on HttpException {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('An unexpected error ocurred.'),
                  ),
                );
              }
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product added to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartProvider.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              cartProvider.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
