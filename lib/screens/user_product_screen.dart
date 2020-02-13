import 'package:flutter/material.dart';
import 'package:max_shop/widgets/error_message.dart';
import '../widgets/app_menu.dart';
import '../widgets/user_product.dart';
import '../screens/edit_products_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user_product_screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .catchError((error) {
      return showDialog(context: context, builder: (ctx) => ErrorMessage());
    });
//    print('fetch data on refresh >> 0');
  }

  @override
  Widget build(BuildContext context) {
//    final product = Provider.of<Products>(context);
//    print('Build Context Page >> 1');
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
        body: RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Consumer<Products>(
            builder: (ctx, product, _) => ListView.builder(
              itemBuilder: (ctx, i) => UserProduct(
                product.items[i].id,
                product.items[i].title,
                product.items[i].price,
                product.items[i].imageUrl,
              ),
              itemCount: product.items.length,
            ),
          ),
        ));
  }
}
