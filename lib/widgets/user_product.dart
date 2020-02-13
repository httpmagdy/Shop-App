import 'package:flutter/material.dart';
import 'package:max_shop/providers/products.dart';
import '../screens/edit_products_screen.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  UserProduct(this.id, this.title, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold =Scaffold.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        subtitle: Text(price.toString()),
        trailing: Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductsScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete_outline,color: Theme.of(context).errorColor,),
                onPressed: () async{
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  }catch(error){
                    scaffold.showSnackBar(SnackBar(
                      content: Text('Deleting failed!', textAlign: TextAlign.center,),
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
              ),
            ],
          ),
        ));
  }
}
