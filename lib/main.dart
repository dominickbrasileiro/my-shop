import 'package:flutter/material.dart';
import 'package:fshop/core/app_routes.dart';
import 'package:fshop/providers/cart_provider.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/providers/products_provider.dart';
import 'package:fshop/screens/auth_screen.dart';
import 'package:fshop/screens/cart_screen.dart';
import 'package:fshop/screens/manage_products_screen.dart';
import 'package:fshop/screens/orders_screen.dart';
import 'package:fshop/screens/product_details_screen.dart';
import 'package:fshop/screens/product_form_screen.dart';
import 'package:fshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
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
        initialRoute: AppRoutes.AUTH,
        routes: {
          AppRoutes.AUTH: (ctx) => AuthScreen(),
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
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
