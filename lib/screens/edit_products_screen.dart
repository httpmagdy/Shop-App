import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = 'edit_prodct_screen';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  var _editProodct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initProduct = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  bool _isInit = true;

  void _imageUrllistener() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_imageUrllistener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;

      if (prodId != null) {
        _editProodct =
            Provider.of<Products>(context, listen: false).findById(prodId);

        _initProduct = {
          'title': _editProodct.title,
          'price': _editProodct.price.toString(),
          'description': _editProodct.description,
          // 'imageUrl': '',
        };
        _imageUrlController.text = _editProodct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_imageUrllistener);
    _descFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProd() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProodct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProodct.id, _editProodct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProodct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Somthing went wrong.'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Oky!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Prodct'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveProd()),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initProduct['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter the title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProodct = Product(
                          id: _editProodct.id,
                          title: value,
                          price: _editProodct.price,
                          description: _editProodct.description,
                          imageUrl: _editProodct.imageUrl,
                          isFavorite: _editProodct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valide numbers!';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProodct = Product(
                          id: _editProodct.id,
                          title: _editProodct.title,
                          price: double.parse(value),
                          description: _editProodct.description,
                          imageUrl: _editProodct.imageUrl,
                          isFavorite: _editProodct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.newline,
                      focusNode: _descFocusNode,
                      maxLines: 3,
                      maxLength: 100,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the Description';
                        }
                        if (value.length < 9) {
                          return 'Should be at 9 charaster long';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editProodct = Product(
                          id: _editProodct.id,
                          title: _editProodct.title,
                          price: _editProodct.price,
                          description: value,
                          imageUrl: _editProodct.imageUrl,
                          isFavorite: _editProodct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10.0, right: 8.0),
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter image URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                          // https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initProduct['imageUrl'],
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onSaved: (value) {
                              _editProodct = Product(
                                id: _editProodct.id,
                                title: _editProodct.title,
                                price: _editProodct.price,
                                description: _editProodct.description,
                                imageUrl: value,
                                isFavorite: _editProodct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'Please enter a valid URL.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _saveProd();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
