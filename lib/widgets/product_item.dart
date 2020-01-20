import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsScreen.routeName,
          arguments: prod.id,
        );
      },
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    prod.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          _iconsCircle(
                            prod: prod,
                            icon: Icon(
                              prod.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Theme.of(context).accentColor,
                            ),
                            onPress: () {
                              prod.toggleFavoriteStatus();
                            },
                          ),
                          _iconsCircle(
                              prod: prod,
                              icon: Icon(Icons.shopping_cart),
                              onPress: () {
                                cart.addItem(prod.id, prod.title, prod.price);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Added ${prod.title} To Cart!'),
                                  duration: Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: (){
                                      cart.removeSingleItem(prod.id);
                                    },
                                  ),
                                ));
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  Text(
                    '\$${prod.price.toString()}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _iconsCircle({Product prod, Icon icon, Function onPress}) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 15,
      child: IconButton(
        icon: icon,
        iconSize: 15,
        onPressed: onPress,
      ),
    ),
  );
}
