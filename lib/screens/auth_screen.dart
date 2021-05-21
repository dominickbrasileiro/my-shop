import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fshop/widgets/auth_card_widget.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE53935),
                  Color(0xFFE35D5B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 6,
                      ),
                      transform: Matrix4.rotationZ(pi / -24)..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline1
                              ?.color,
                          fontFamily: 'Anton',
                          fontSize: 45,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    AuthCardWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
