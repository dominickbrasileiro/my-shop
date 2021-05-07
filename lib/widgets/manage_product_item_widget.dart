import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/core/exceptions/http_exception.dart';
import 'package:fshop/models/product.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ManageProductItemWidget extends StatelessWidget {
  final Product product;

  ManageProductItemWidget({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                final userConfirms = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to delete "${product.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes'),
                      )
                    ],
                  ),
                );

                if (userConfirms != null && userConfirms) {
                  final productsProvider =
                      Provider.of<ProductsProvider>(context, listen: false);

                  try {
                    await productsProvider.deleteProduct(product.id);
                  } on HttpException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('$e'),
                    ));
                  }
                }
              },
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
