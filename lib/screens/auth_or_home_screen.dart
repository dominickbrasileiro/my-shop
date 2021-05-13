import 'package:flutter/material.dart';
import 'package:fshop/providers/auth_provider.dart';
import 'package:fshop/screens/auth_screen.dart';
import 'package:fshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isAuthenticated
        ? ProductsOverviewScreen()
        : AuthScreen();
  }
}
