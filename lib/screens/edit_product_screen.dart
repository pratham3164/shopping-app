import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class EditProductScreeen extends StatefulWidget {
  static const routeName = '/editProductScreen';

  @override
  _EditProductScreeenState createState() => _EditProductScreeenState();
}

class _EditProductScreeenState extends State<EditProductScreeen> {
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imagecontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var editedProduct = Product(id: null, title: '', price: 0.0, imageUrl: '');
  bool isInit = false;
  var initValue = {
    'id': null,
    'title': '',
    'price': '',
    'imageURL': '',
    'isfav': false
  };
  bool isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        final product = Provider.of<Products>(context).findById(productID);
        editedProduct = product;
        initValue = initValue = {
          'id': product.id,
          'title': product.title,
          'price': product.price.toString(),
          'imageURL': product.imageUrl,
          'isfav': product.isfav
        };
        _imagecontroller.text = product.imageUrl;
      }
    }
    isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _imagecontroller.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void changeStateAndPop() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    setState(() {
      isLoading = true;
    });

    if (editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProductItem(editedProduct.id, editedProduct);
      } catch (error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong!!'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          changeStateAndPop();
                        },
                        child: Text('ok'))
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProductItem(editedProduct);
      } catch (error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong!!'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          changeStateAndPop();
                        },
                        child: Text('ok'))
                  ],
                ));
      }
    }
    changeStateAndPop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save), onPressed: () => saveForm())
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: initValue['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'title cannot be null';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            editedProduct = Product(
                                id: editedProduct.id,
                                title: value,
                                price: editedProduct.price,
                                imageUrl: editedProduct.imageUrl);
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                        ),
                        TextFormField(
                          initialValue: initValue['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'price cannot be null';
                            } else if (double.parse(value) <= 0.0) {
                              return 'price cannot be <= 0.0';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            editedProduct = Product(
                                id: editedProduct.id,
                                title: editedProduct.title,
                                price: double.parse(value),
                                imageUrl: editedProduct.imageUrl);
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_imageFocusNode);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 8, right: 10),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: _imagecontroller.text.isEmpty
                                    ? Center(
                                        child: FittedBox(
                                            child: Text('Enter Image URL')))
                                    : FittedBox(
                                        child: Image.network(
                                            _imagecontroller.text))),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                focusNode: _imageFocusNode,
                                controller: _imagecontroller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'enter a URL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Enter a valid URL';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Enter a valid URL';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  editedProduct = Product(
                                      id: editedProduct.id,
                                      title: editedProduct.title,
                                      price: editedProduct.price,
                                      imageUrl: value);
                                },
                                onFieldSubmitted: (_) => saveForm(),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ));
  }
}
