import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/collection.dart';

class DataService {
  static DataService? _instance;
  static DataService get instance => _instance ??= DataService._();

  DataService._();

  // For testing purposes
  static void resetInstance() {
    _instance = null;
  }

  List<Product>? _products;
  List<Collection>? _collections;

  // Asset loader function (overridable for tests)
  // Defaults to using Flutter's rootBundle.loadString
  static Future<String> Function(String path) assetLoader =
      (String path) => rootBundle.loadString(path);

  Future<void> _loadData() async {
    if (_products != null && _collections != null) return;

    final String jsonString = await assetLoader('assets/data/products.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    _products = (jsonData['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    _collections = (jsonData['collections'] as List)
        .map((collectionJson) => Collection.fromJson(collectionJson))
        .toList();
  }

  Future<List<Product>> getProducts() async {
    await _loadData();
    return _products!;
  }

  Future<List<Collection>> getCollections() async {
    await _loadData();
    return _collections!;
  }

  Future<List<Product>> getProductsByCollection(String collectionId) async {
    await _loadData();
    return _products!
        .where((product) => product.collectionId == collectionId)
        .toList();
  }

  Future<Product?> getProduct(String productId) async {
    await _loadData();
    try {
      return _products!.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Future<Collection?> getCollection(String collectionId) async {
    await _loadData();
    try {
      return _collections!
          .firstWhere((collection) => collection.id == collectionId);
    } catch (e) {
      return null;
    }
  }

  /// Simple client-side search over loaded products.
  /// Matches against title and description (case-insensitive substring).
  Future<List<Product>> searchProducts(String q) async {
    await _loadData();
    final term = q.toLowerCase().trim();
    if (term.isEmpty) return [];
    return _products!
        .where((p) =>
            p.title.toLowerCase().contains(term) ||
            p.description.toLowerCase().contains(term))
        .toList();
  }
}
