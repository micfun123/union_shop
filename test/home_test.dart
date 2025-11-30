import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Home Page Tests', () {
    Future<void> settle(WidgetTester tester) async {
      // Limited pump loop to avoid pumpAndSettle hanging on network/image futures
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pump();
    }

    setUp(() {
      // Override the DataService assetLoader to return fixture JSON directly.
      DataService.resetInstance();
      DataService.assetLoader = (String path) async => '''{
  "collections": [],
  "products": [
    {
      "id": "p1",
      "title": "Placeholder Product 1",
      "price": "10.00",
      "currency": "£",
      "collectionId": "c1",
      "imageUrl": "",
      "description": "A placeholder product",
      "inStock": true
    },
    {
      "id": "p2",
      "title": "Placeholder Product 2",
      "price": "15.00",
      "currency": "£",
      "collectionId": "c1",
      "imageUrl": "",
      "description": "A placeholder product",
      "inStock": true
    },
    {
      "id": "p3",
      "title": "Placeholder Product 3",
      "price": "20.00",
      "currency": "£",
      "collectionId": "c1",
      "imageUrl": "",
      "description": "A placeholder product",
      "inStock": true
    },
    {
      "id": "p4",
      "title": "Placeholder Product 4",
      "price": "25.00",
      "currency": "£",
      "collectionId": "c1",
      "imageUrl": "",
      "description": "A placeholder product",
      "inStock": true
    }
  ]
}''';
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        null,
      );
      DataService.resetInstance();
    });

    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(
        UnionShopApp(cartNotifier: ValueNotifier<Cart>(Cart())),
      );
      await settle(tester);

      // Check that basic UI elements are present
      expect(
        find.text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
        findsOneWidget,
      );
      expect(find.text('2026 Union Shop'), findsOneWidget);
      expect(find.text('An exciting new year for the Union Shop.'),
          findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(
        UnionShopApp(cartNotifier: ValueNotifier<Cart>(Cart())),
      );
      await settle(tester);

      // Check that product cards are displayed
      expect(find.text('Placeholder Product 1'), findsOneWidget);
      expect(find.text('Placeholder Product 2'), findsOneWidget);
      expect(find.text('Placeholder Product 3'), findsOneWidget);
      expect(find.text('Placeholder Product 4'), findsOneWidget);

      // Check prices are displayed
      expect(find.text('£10.00'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(
        UnionShopApp(cartNotifier: ValueNotifier<Cart>(Cart())),
      );
      await settle(tester);

      // Check that header icons are present (desktop layout used in tests)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(
        UnionShopApp(cartNotifier: ValueNotifier<Cart>(Cart())),
      );
      await settle(tester);

      // Check that footer is present
      expect(
          find.text('© 2024 Union Shop. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('browse products button should be tappable', (tester) async {
      await tester.pumpWidget(
        UnionShopApp(cartNotifier: ValueNotifier<Cart>(Cart())),
      );
      await settle(tester);

      // Tap the browse products button
      final browseButton = find.text('BROWSE PRODUCTS');
      expect(browseButton, findsOneWidget);
      await tester.tap(browseButton);
      await settle(tester);

      // Verify navigation to collections page
      expect(find.text('Collections'), findsOneWidget);
    });
  });
}
