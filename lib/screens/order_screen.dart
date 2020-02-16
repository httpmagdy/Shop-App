import 'package:flutter/material.dart';
import '../widgets/app_menu.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {

//    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppMenu(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, _) =>
                    ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    ),
              );
            }
          }
        },
      ),
    );
  }
}
