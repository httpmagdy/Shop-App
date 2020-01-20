import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_menu.dart';
import '../widgets/products_grid.dart';
import '../widgets/bage.dart';
import './cart_screen.dart';
import '../providers/cart.dart';

enum SelectOption { all, favorite }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppMenu(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (SelectOption onSelected) {
              setState(() {
                onSelected == SelectOption.all
                    ? _isFavorite = false
                    : _isFavorite = true;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('All'),
                value: SelectOption.all,
              ),
              PopupMenuItem(
                child: Text('Your Favorite'),
                value: SelectOption.favorite,
              )
            ],
          ),


          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),

        ],
      ),
      body: ProductsGrid(_isFavorite),
    );
  }
}
