import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Product Page Tests', () {
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
      "id": "test-product",
      "title": "Test Product",
      "price": "15.00",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/image.jpg",
      "description": "This is a test product description.",
      "inStock": true
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
      DataService.resetInstance();
    });

    Widget createTestWidget() {
      return const MaterialApp(home: ProductPage(productId: 'test-product'));
    }

    Widget createTestWidgetWithInvalidId() {
      return const MaterialApp(home: ProductPage(productId: 'invalid-id'));
    }

    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display product page with loaded data', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(
        find.text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
        findsOneWidget,
      );
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('This is a test product description.'), findsOneWidget);
    });

    testWidgets('should display product not found for invalid ID',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithInvalidId());
      await tester.pumpAndSettle();

      expect(find.text('Product not found'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that header icons are present (desktop layout used in tests)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that footer is present
      expect(
          find.text('© 2024 Union Shop. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
}
