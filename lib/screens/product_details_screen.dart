import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = 'product-details-screen';
  @override
  Widget build(BuildContext context) {

    final _prodId = ModalRoute.of(context).settings.arguments;
    final _lodadedData = Provider.of<Products>(context, listen: false).findById(_prodId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_lodadedData.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(height: 270 ,child: Image.network(_lodadedData.imageUrl, fit: BoxFit.cover,)),
            Text(_lodadedData.price.toString()),
            Text(_lodadedData.description),
          ],
        ),
      ),
    );
  }
}