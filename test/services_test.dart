import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/collection.dart';

void main() {
  group('DataService Tests', () {
    setUp(() {
      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            if (methodCall.arguments == 'assets/data/products.json') {
              return '''{
  "collections": [
    {
      "id": "test-collection",
      "name": "Test Collection",
      "description": "Test description",
      "imageUrl": "https://example.com/image.jpg"
    }
  ],
  "products": [
    {
      "id": "test-product-1",
      "title": "Test Product 1",
      "price": "10.00",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/image1.jpg",
      "description": "Test description 1",
      "inStock": true
    },
    {
      "id": "test-product-2",
      "title": "Test Product 2",
      "price": "15.00",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/image2.jpg",
      "description": "Test description 2",
      "inStock": false
    }
  ]
}''';
            }
          }
          return null;
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        null,
      );
      // Reset the DataService instance
      DataService.resetInstance();
    });

    test('should load and return products', () async {
      final dataService = DataService.instance;
      final products = await dataService.getProducts();

      expect(products.length, 2);
      expect(products[0].id, 'test-product-1');
      expect(products[0].title, 'Test Product 1');
      expect(products[1].id, 'test-product-2');
      expect(products[1].title, 'Test Product 2');
    });

    test('should load and return collections', () async {
      final dataService = DataService.instance;
      final collections = await dataService.getCollections();

      expect(collections.length, 1);
      expect(collections[0].id, 'test-collection');
      expect(collections[0].name, 'Test Collection');
    });

    test('should return products by collection', () async {
      final dataService = DataService.instance;
      final products =
          await dataService.getProductsByCollection('test-collection');

      expect(products.length, 2);
      expect(products[0].collectionId, 'test-collection');
      expect(products[1].collectionId, 'test-collection');
    });

    test('should return specific product by ID', () async {
      final dataService = DataService.instance;
      final product = await dataService.getProduct('test-product-1');

      expect(product, isNotNull);
      expect(product!.id, 'test-product-1');
      expect(product.title, 'Test Product 1');
    });

    test('should return null for non-existent product', () async {
      final dataService = DataService.instance;
      final product = await dataService.getProduct('non-existent');

      expect(product, isNull);
    });

    test('should return specific collection by ID', () async {
      final dataService = DataService.instance;
      final collection = await dataService.getCollection('test-collection');

      expect(collection, isNotNull);
      expect(collection!.id, 'test-collection');
      expect(collection.name, 'Test Collection');
    });

    test('should return null for non-existent collection', () async {
      final dataService = DataService.instance;
      final collection = await dataService.getCollection('non-existent');

      expect(collection, isNull);
    });

    test('should cache data after first load', () async {
      final dataService = DataService.instance;

      // First call loads data
      final products1 = await dataService.getProducts();

      // Second call should return cached data
      final products2 = await dataService.getProducts();

      expect(products1, same(products2));
    });
  });
}
