import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  final _isFavs;
  ProductsGrid(this._isFavs);

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Products>(context, listen: false);
    final _prodData = _isFavs ? prod.showFavorite : prod.items;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _prodData.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: _prodData[i],
          child: ProductItem(),
        ),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
      ),
    );
  }
}
