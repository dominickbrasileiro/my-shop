import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/providers/auth_provider.dart';
import 'package:fshop/providers/cart_provider.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:fshop/screens/auth_or_home_screen.dart';
import 'package:fshop/screens/cart_screen.dart';
import 'package:fshop/screens/manage_products_screen.dart';
import 'package:fshop/screens/orders_screen.dart';
import 'package:fshop/screens/product_details_screen.dart';
import 'package:fshop/screens/product_form_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider(token: null, items: []),
          update: (ctx, authProvider, productsProvider) => ProductsProvider(
            token: authProvider.token,
            userId: authProvider.userId,
            items: productsProvider!.products,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => OrdersProvider(token: null, items: []),
          update: (ctx, authProvider, ordersProvider) => OrdersProvider(
            token: authProvider.token,
            items: ordersProvider!.orders,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        initialRoute: AppRoutes.AUTH_OR_HOME_SCREEN,
        routes: {
          AppRoutes.AUTH_OR_HOME_SCREEN: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAILS: (ctx) => ProductDetailsScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.MANAGE_PRODUCTS: (ctx) => ManageProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
