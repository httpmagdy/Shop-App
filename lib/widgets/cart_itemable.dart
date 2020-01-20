import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemable extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItemable(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          size: 30.0,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx)=> AlertDialog(
          title: Text('Are you sure'),
          content: Text('Do you want to remoe this item from the cart'),
          actions: <Widget>[
            FlatButton(child: Text('Yes'), onPressed: ()=> Navigator.pop(ctx, true),),
            FlatButton(child: Text('No'), onPressed: ()=> Navigator.pop(ctx, false),),
          ],
        ),);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: FittedBox(child: Text('\$${price.toString()}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
