import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fshop/models/product.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late FocusNode _priceFocusNode;
  late FocusNode _descriptionFocusNode;
  late FocusNode _imageUrlFocusNode;
  late TextEditingController _imageUrlController;
  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object?>();

  @override
  void initState() {
    super.initState();

    _priceFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _imageUrlFocusNode = FocusNode();
    _imageUrlFocusNode.addListener(handleImageUrlFocusChange);
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(handleImageUrlFocusChange);
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void handleImageUrlFocusChange() {
    if (validateUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool validateUrl(String url) {
    final bool startsWithHttp = url.toLowerCase().startsWith('http://');
    final bool startsWithHttps = url.toLowerCase().startsWith('https://');

    final bool endsWithPng = url.toLowerCase().endsWith('.png');
    final bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    final bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startsWithHttp || startsWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  void _saveForm() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    final newProduct = Product(
      id: Random().nextInt(33),
      title: _formData['title'] as String,
      price: _formData['price'] as double,
      description: _formData['description'] as String,
      imageUrl: _formData['imageUrl'] as String,
    );

    print(newProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Form'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _priceFocusNode.requestFocus(),
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }

                  if (value.trim().length < 3) {
                    return 'Title must contain 3 characters at least';
                  }

                  return null;
                },
              ),
              TextFormField(
                focusNode: _priceFocusNode,
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) => _descriptionFocusNode.requestFocus(),
                onSaved: (value) {
                  _formData['price'] = value != null && value.isNotEmpty
                      ? double.parse(value)
                      : null;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }

                  final double? parsedPrice = double.tryParse(value);

                  if (parsedPrice == null) {
                    return 'Invalid format';
                  }

                  if (parsedPrice <= 0) {
                    return 'Price must be greater than 0';
                  }
                },
              ),
              TextFormField(
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _formData['description'] = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) => _formData['imageUrl'] = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Image URL is required';
                        }

                        if (!validateUrl(value)) {
                          return 'Invalid format';
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 16,
                      left: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text(
                            'Enter Image URL',
                            textAlign: TextAlign.center,
                          )
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
