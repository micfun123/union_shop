import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pages/collections.dart';
import 'package:union_shop/services/data_service.dart';

void main() {
  group('Collections Page Tests', () {
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
      "id": "study-essentials",
      "name": "Study Essentials",
      "description": "Everything you need for your studies",
      "imageUrl": "https://example.com/study.jpg"
    },
    {
      "id": "university-apparel",
      "name": "University Apparel",
      "description": "Show your Portsmouth pride",
      "imageUrl": "https://example.com/apparel.jpg"
    }
  ],
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

    Widget createTestWidget() {
      return const MaterialApp(home: CollectionsPage());
    }

    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display collections page with loaded data',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check page title and description
      expect(find.text('Collections'), findsOneWidget);
      expect(
        find.text(
            'Browse curated collections of products. Tap a collection to view items.'),
        findsOneWidget,
      );

      // Check that collections are displayed
      expect(find.text('Study Essentials'), findsOneWidget);
      expect(find.text('University Apparel'), findsOneWidget);
      expect(find.text('Everything you need for your studies'), findsOneWidget);
      expect(find.text('Show your Portsmouth pride'), findsOneWidget);
    });

    testWidgets('should display collection cards in grid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that cards are present
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display header and footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check header
      expect(
        find.text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!'),
        findsOneWidget,
      );

      // Check footer
      expect(
          find.text('© 2024 Union Shop. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('collection cards should be tappable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the first collection card
      final firstCard = find.byType(InkWell).first;
      expect(firstCard, findsOneWidget);

      // The tap action would normally navigate, but in tests it just completes
      await tester.tap(firstCard);
      await tester.pumpAndSettle();
    });
  });
}
