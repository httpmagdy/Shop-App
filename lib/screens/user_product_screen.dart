import 'package:flutter/material.dart';
import 'package:max_shop/widgets/app_menu.dart';
import 'package:max_shop/widgets/user_product.dart';
import '../screens/edit_products_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user_product_screen';
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Prodcts'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, EditProductsScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppMenu(),
        body: ListView.builder(
          itemBuilder: (ctx, i) => UserProduct(
            product.items[i].id,
            product.items[i].title,
            product.items[i].price,
            product.items[i].imageUrl,
          ),
          itemCount: product.items.length,
        ));
  }
}
