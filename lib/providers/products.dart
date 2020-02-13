import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import '../models/url_api.dart';
import 'dart:convert';

// "https://i.ibb.co/ZGqSx0D/001.jpg"
// "https://i.ibb.co/JskrFSH/002.jpg"
// "https://i.ibb.co/sj6MsNZ/003.jpg"
// "https://i.ibb.co/N64pzVR/004.jpg"
// "https://i.ibb.co/nM4yLby/006.jpg"
// "https://i.ibb.co/k2Zb3J4/007.jpg"
// "https://i.ibb.co/X7nQSHy/008.jpg"
// "https://i.ibb.co/mX9jY29/009.jpg"
// "https://i.ibb.co/cDSsVbz/010.jpg"
// "https://i.ibb.co/rdx7zZQ/011.jpg"
// "https://i.ibb.co/f4KDq6r/012.jpg"

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavorite {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String prodId) {
    return _items.firstWhere((prod) => prod.id == prodId);
  }

  Future<void> fetchAndSetProducts() async {
    const url = '$api/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){return;}
      final List<Product> loadedData = [];

      extractedData.forEach(
        (proKey, proData) => {
          loadedData.add(
            Product(
              id: proKey,
              title: proData['title'],
              description: proData['description'],
              price: proData['price'],
              imageUrl: proData['imageUrl'],
              isFavorite: proData['isFavorite'],
            ),
          ),
        },
      );
      _items = loadedData;
      notifyListeners();
    } catch (error) {
//      print('Product {GIT} ERROR: >> $error');
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = '$api/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      final _newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
//      print('Product {POST} ERROR: >> $error');
      throw (error);
    }
  }

  void updateProduct(String id, Product newProduct) {
    final _indexProduct = _items.indexWhere((prodId) => prodId.id == id);

    if (_indexProduct >= 0) {
      _items[_indexProduct] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
