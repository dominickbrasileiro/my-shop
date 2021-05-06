import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/providers/cart_provider.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:fshop/widgets/app_drawer.dart';
import 'package:fshop/widgets/badge_widget.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
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
          Consumer<CartProvider>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (ctx, cart, child) => BadgeWidget(
              value: '${cart.itemCount}',
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              products: _showFavoritesOnly
                  ? productsProvider.favoriteProducts
                  : productsProvider.products,
            ),
    );
  }
}
