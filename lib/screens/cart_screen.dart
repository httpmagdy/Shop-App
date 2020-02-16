import 'package:flutter/material.dart';
import 'package:max_shop/providers/order.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_itemable.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  OrderNowButton(cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.values.length,
              itemBuilder: (ctx, i) => CartItemable(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }}


class OrderNowButton extends StatefulWidget {
  final Cart cart;
  const OrderNowButton(this.cart);

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cart.totalAmount <= 0) ? null : () async{

        setState(() {
          isLoading = true;
        });

        await Provider.of<Orders>(context, listen: false).addOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        ).then((_){
          setState(() {
            isLoading = false;
          });
        });


        widget.cart.clear();
      },
    );
  }
}

