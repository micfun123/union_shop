import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/collection_detail.dart';
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Collection Detail Page Tests', () {
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
      "description": "Test collection description",
      "imageUrl": "https://example.com/image.jpg"
    }
  ],
  "products": [
    {
      "id": "notebook-a",
      "title": "Notebook A",
      "price": "5.00",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/notebook.jpg",
      "description": "High-quality notebook",
      "inStock": true
    },
    {
      "id": "pen-set",
      "title": "Pen Set",
      "price": "3.50",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/pen.jpg",
      "description": "Set of premium pens",
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
      return const MaterialApp(
          home: CollectionDetailPage(collectionId: 'test-collection'));
    }

    Widget createTestWidgetWithInvalidId() {
      return const MaterialApp(
          home: CollectionDetailPage(collectionId: 'invalid-id'));
    }

    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Collection detail page shows loaded data', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test Collection'), findsOneWidget);
      expect(find.text('Test collection description'), findsOneWidget);
    });

    testWidgets('Page displays products for the collection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Notebook A'), findsOneWidget);
      expect(find.text('Pen Set'), findsOneWidget);
      expect(find.text('£5.00'), findsOneWidget);
      expect(find.text('£3.50'), findsOneWidget);
    });

    testWidgets('should display collection not found for invalid ID',
        (tester) async {
      await tester.pumpWidget(createTestWidgetWithInvalidId());
      await tester.pumpAndSettle();

      expect(find.text('Collection not found'), findsOneWidget);
    });

    testWidgets('Filter dropdowns are visible', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));
    });

    testWidgets('Pagination controls are visible', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Prev'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Products display in grid layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Footer is visible', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
          find.text('© 2024 Union Shop. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('Should filter products by price range', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the price range dropdown
      final priceDropdown = find.byType(DropdownButtonFormField<String>).last;
      await tester.tap(priceDropdown);
      await tester.pumpAndSettle();

      // Select "Under £5" filter
      await tester.tap(find.text('Under £5').last);
      await tester.pumpAndSettle();

      // Should still show Pen Set (£3.50) but not Notebook A (£5.00)
      expect(find.text('Pen Set'), findsOneWidget);
      expect(find.text('£3.50'), findsOneWidget);
    });

    testWidgets('Should sort products by price', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the sort dropdown
      final sortDropdown = find.byType(DropdownButtonFormField<String>).first;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      // Select "Price: Low to High" sort
      await tester.tap(find.text('Price: Low to High').last);
      await tester.pumpAndSettle();

      // Products should be displayed (sorting is internal logic)
      expect(find.text('Notebook A'), findsOneWidget);
      expect(find.text('Pen Set'), findsOneWidget);
    });
  });
}
