import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Integration Tests', () {
    setUp(() {
      // Mock the asset bundle with full data
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            if (methodCall.arguments == 'assets/data/products.json') {
              return '''{
  "collections": [
    {
      "id": "study-essentials",
      "name": "Study Essentials",
      "description": "Everything you need for your studies",
      "imageUrl": "https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561"
    },
    {
      "id": "university-apparel",
      "name": "University Apparel",
      "description": "Show your Portsmouth pride",
      "imageUrl": "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282"
    }
  ],
  "products": [
    {
      "id": "notebook-a",
      "title": "Notebook A",
      "price": "5.00",
      "currency": "£",
      "collectionId": "study-essentials",
      "imageUrl": "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282",
      "description": "High-quality notebook for all your study needs",
      "inStock": true
    },
    {
      "id": "portsmouth-tshirt",
      "title": "Portsmouth University T-Shirt",
      "price": "15.00",
      "currency": "£",
      "collectionId": "university-apparel",
      "imageUrl": "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282",
      "description": "Official Portsmouth University branded t-shirt",
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

    testWidgets('Full app navigation flow', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Should start at home page
      expect(find.text('Placeholder Hero Title'), findsOneWidget);
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);

      // Navigate to collections via header
      final shopButton = find.text('Shop');
      expect(shopButton, findsOneWidget);
      await tester.tap(shopButton);
      await tester.pumpAndSettle();

      // Should be on collections page
      expect(find.text('Collections'), findsOneWidget);
      expect(find.text('Study Essentials'), findsOneWidget);
      expect(find.text('University Apparel'), findsOneWidget);

      // Tap on a collection
      final studyEssentialsCard = find.text('Study Essentials');
      await tester.tap(studyEssentialsCard);
      await tester.pumpAndSettle();

      // Should be on collection detail page
      expect(find.text('Study Essentials'), findsOneWidget);
      expect(find.text('Everything you need for your studies'), findsOneWidget);
      expect(find.text('Notebook A'), findsOneWidget);

      // Tap on a product
      final notebookCard = find.text('Notebook A');
      await tester.tap(notebookCard);
      await tester.pumpAndSettle();

      // Should be on product page
      expect(find.text('Notebook A'), findsOneWidget);
      expect(find.text('£5.00'), findsOneWidget);
      expect(find.text('High-quality notebook for all your study needs'),
          findsOneWidget);
    });

    testWidgets('Header navigation works across pages', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Test Home navigation
      final homeButton = find.text('Home');
      await tester.tap(homeButton);
      await tester.pumpAndSettle();
      expect(find.text('Placeholder Hero Title'), findsOneWidget);

      // Test About navigation
      final aboutButton = find.text('About');
      await tester.tap(aboutButton);
      await tester.pumpAndSettle();
      // About page should load (content depends on implementation)

      // Test Auth navigation
      final authIcon = find.byIcon(Icons.person_outline);
      await tester.tap(authIcon);
      await tester.pumpAndSettle();
      // Auth page should load (content depends on implementation)
    });

    testWidgets('Data service integration works correctly', (tester) async {
      // Test data service directly
      final dataService = DataService.instance;

      final collections = await dataService.getCollections();
      expect(collections.length, 2);
      expect(collections[0].name, 'Study Essentials');

      final products = await dataService.getProducts();
      expect(products.length, 2);
      expect(products[0].title, 'Notebook A');

      final studyProducts =
          await dataService.getProductsByCollection('study-essentials');
      expect(studyProducts.length, 1);
      expect(studyProducts[0].title, 'Notebook A');
    });
  });
}
