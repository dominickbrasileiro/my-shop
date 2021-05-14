import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fshop/core/app_constants.dart';
import 'package:fshop/core/exceptions/http_exception.dart';
import 'package:fshop/models/partial_product.dart';
import 'package:fshop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> items = [];
  late String? token;
  late String? userId;

  ProductsProvider({
    required this.items,
    this.token,
    this.userId,
  });

  List<Product> get products => [...items];

  int get itemCount => items.length;

  Future<void> fetchProducts() async {
    final productsUrl =
        Uri.parse('${AppConstants.BASE_API_URL}/products.json?auth=$token');
    final productsResponse = await http.get(productsUrl);
    Map<String, dynamic>? productsData = json.decode(productsResponse.body);

    final favoritesUrl = Uri.parse(
        '${AppConstants.BASE_API_URL}/userFavorites/$userId.json?auth=$token');
    final favoritesResponse = await http.get(favoritesUrl);
    Map<String, dynamic>? favoritesData = json.decode(favoritesResponse.body);

    if (productsData != null) {
      items.clear();

      productsData.forEach((id, productData) {
        final isFavorite =
            favoritesData == null ? false : favoritesData[id] ?? false;

        items.add(Product(
          id: id,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });

      notifyListeners();
    }
  }

  List<Product> get favoriteProducts =>
      items.where((product) => product.isFavorite).toList();

  Future<void> addProduct(PartialProduct partialProduct) async {
    final url =
        Uri.parse('${AppConstants.BASE_API_URL}/products.json?auth=$token');
    final response = await http.post(
      url,
      body: json.encode({
        'title': partialProduct.title,
        'description': partialProduct.description,
        'price': partialProduct.price,
        'imageUrl': partialProduct.imageUrl,
      }),
    );

    final id = json.decode(response.body)['name'];

    items.add(Product(
      id: id,
      title: partialProduct.title,
      price: partialProduct.price,
      description: partialProduct.description,
      imageUrl: partialProduct.imageUrl,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final productIndex =
        items.indexWhere((_product) => _product.id == product.id);

    if (productIndex < 0) {
      return;
    }

    final url = Uri.parse(
        '${AppConstants.BASE_API_URL}/products/${product.id}.json?auth=$token');
    final response = await http.patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    if (response.statusCode >= 400) {
      throw new HttpException();
    }

    items[productIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final index = items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      final product = items[index];

      items.removeWhere((product) => product.id == id);
      notifyListeners();

      final url = Uri.parse(
          '${AppConstants.BASE_API_URL}/products/${product.id}.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        items.insert(index, product);
        notifyListeners();

        throw HttpException();
      }
    }
  }

  Future<void> toggleFavoriteById(String id) async {
    final product = items.firstWhere((product) => product.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();

    final url = Uri.parse(
        '${AppConstants.BASE_API_URL}/userFavorites/$userId/${product.id}.json?auth=$token');
    final response = await http.put(
      url,
      body: json.encode(product.isFavorite),
    );

    if (response.statusCode >= 400) {
      product.isFavorite = !product.isFavorite;
      notifyListeners();

      throw HttpException();
    }
  }
}
