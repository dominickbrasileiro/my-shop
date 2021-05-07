import 'package:flutter/material.dart';
import 'package:fshop/models/cart_item.dart';
import 'package:fshop/providers/cart_provider.dart';
import 'package:fshop/providers/orders_provider.dart';
import 'package:fshop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items.values.toList();

    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '\$ ${cartProvider.totalAmount}',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            Theme.of(context).primaryTextTheme.headline1!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  CheckoutButton(
                    cartProvider: cartProvider,
                    ordersProvider: ordersProvider,
                    cartItems: cartItems,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.itemCount,
              itemBuilder: (ctx, i) => CartItemWidget(
                cartItem: cartItems[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({
    Key? key,
    required this.cartProvider,
    required this.ordersProvider,
    required this.cartItems,
  }) : super(key: key);

  final CartProvider cartProvider;
  final OrdersProvider ordersProvider;
  final List<CartItem> cartItems;

  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartProvider.totalAmount == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await widget.ordersProvider.addOrder(
                widget.cartItems,
                widget.cartProvider.totalAmount,
              );
              widget.cartProvider.clear();

              setState(() {
                _isLoading = false;
              });
            },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor,
        ),
      ),
      child: _isLoading
          ? Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text('CHECKOUT'),
    );
  }
}
