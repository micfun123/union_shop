import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Search Tests', () {
    setUp(() {
      // Use the project's real products.json file for tests.
      DataService.assetLoader = (String path) async {
        final file = File('assets/data/products.json');
        return file.readAsString();
      };
    });

    tearDown(() {
      DataService.resetInstance();
    });

    test('DataService.searchProducts returns matching products', () async {
      final results = await DataService.instance.searchProducts('Portsmouth');
      expect(results, isA<List<Product>>());
      // Expect at least the T-Shirt and Hoodie to be returned
      expect(results.length >= 2, isTrue);
      final ids = results.map((r) => r.id).toSet();
      expect(ids.contains('portsmouth-tshirt'), isTrue);
      expect(ids.contains('portsmouth-hoodie'), isTrue);
    });

});
}
