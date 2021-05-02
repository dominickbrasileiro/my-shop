import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/models/product.dart';

class ManageProductItemWidget extends StatelessWidget {
  final Product product;

  ManageProductItemWidget({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
