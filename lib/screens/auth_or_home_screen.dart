import 'package:flutter/material.dart';
import 'package:fshop/providers/auth_provider.dart';
import 'package:fshop/screens/auth_screen.dart';
import 'package:fshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.error != null) {
          return Scaffold(
            body: Center(
              child: Text(
                'An unexpected error ocurred. Please try again later.',
              ),
            ),
          );
        }

        return authProvider.isAuthenticated
            ? ProductsOverviewScreen()
            : AuthScreen();
      },
    );
  }
}
