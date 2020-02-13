import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './screens/edit_products_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_oerview_screen.dart';
import './screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.red,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx)=> ProductDetailsScreen(),
          CartScreen.routeName: (ctx)=> CartScreen(),
          OrdersScreen.routeName: (ctx)=> OrdersScreen(),
          UserProductScreen.routeName: (ctx)=> UserProductScreen(),
          EditProductsScreen.routeName: (ctx)=> EditProductsScreen(),
        },
        
      ),
    );
  }
}
