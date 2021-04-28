import 'package:flutter/material.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:fshop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  all,
  favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                _showFavoritesOnly = selectedValue == FilterOptions.favorites;
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      body: ProductGrid(
        products: _showFavoritesOnly
            ? productsProvider.favoriteProducts
            : productsProvider.products,
      ),
    );
  }
}
