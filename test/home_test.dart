import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/router.dart' as router;
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Home Page Tests', () {
    setUp(() {
      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            if (methodCall.arguments == 'assets/data/products.json') {
              return '''{
  "collections": [],
  "products": []
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

    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(
        find.text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
        findsOneWidget,
      );
      expect(find.text('Placeholder Hero Title'), findsOneWidget);
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that header icons are present (desktop layout used in tests)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      // Check that footer is present
      expect(
          find.text('© 2024 Union Shop. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('browse products button should be tappable', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();

      final browseButton = find.text('BROWSE PRODUCTS');
      expect(browseButton, findsOneWidget);

      // Tap the button (would normally navigate)
      await tester.tap(browseButton);
      await tester.pumpAndSettle();
    });
  });
}
