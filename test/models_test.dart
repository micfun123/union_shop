import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/collection.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product from JSON', () {
      final json = {
        'id': 'test-product',
        'title': 'Test Product',
        'price': '10.00',
        'currency': '£',
        'collectionId': 'test-collection',
        'imageUrl': 'https://example.com/image.jpg',
        'description': 'Test description',
        'inStock': true,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'test-product');
      expect(product.title, 'Test Product');
      expect(product.price, '10.00');
      expect(product.currency, '£');
      expect(product.collectionId, 'test-collection');
      expect(product.imageUrl, 'https://example.com/image.jpg');
      expect(product.description, 'Test description');
      expect(product.inStock, true);
    });

    test('should convert Product to JSON', () {
      final product = Product(
        id: 'test-product',
        title: 'Test Product',
        price: '10.00',
        currency: '£',
        collectionId: 'test-collection',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        inStock: true,
      );

      final json = product.toJson();

      expect(json['id'], 'test-product');
      expect(json['title'], 'Test Product');
      expect(json['price'], '10.00');
      expect(json['currency'], '£');
      expect(json['collectionId'], 'test-collection');
      expect(json['imageUrl'], 'https://example.com/image.jpg');
      expect(json['description'], 'Test description');
      expect(json['inStock'], true);
    });

    test('should format price correctly', () {
      final product = Product(
        id: 'test-product',
        title: 'Test Product',
        price: '10.00',
        currency: '£',
        collectionId: 'test-collection',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        inStock: true,
      );

      expect(product.formattedPrice, '£10.00');
    });
  });

  group('Collection Model Tests', () {
    test('should create Collection from JSON', () {
      final json = {
        'id': 'test-collection',
        'name': 'Test Collection',
        'description': 'Test description',
        'imageUrl': 'https://example.com/image.jpg',
      };

      final collection = Collection.fromJson(json);

      expect(collection.id, 'test-collection');
      expect(collection.name, 'Test Collection');
      expect(collection.description, 'Test description');
      expect(collection.imageUrl, 'https://example.com/image.jpg');
    });

    test('should convert Collection to JSON', () {
      final collection = Collection(
        id: 'test-collection',
        name: 'Test Collection',
        description: 'Test description',
        imageUrl: 'https://example.com/image.jpg',
      );

      final json = collection.toJson();

      expect(json['id'], 'test-collection');
      expect(json['name'], 'Test Collection');
      expect(json['description'], 'Test description');
      expect(json['imageUrl'], 'https://example.com/image.jpg');
    });
  });
}
