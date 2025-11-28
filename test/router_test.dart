import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/router.dart';
import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/pages/collections.dart';
import 'package:union_shop/pages/collection_detail.dart';
import 'package:union_shop/pages/aboutus.dart';
import 'package:union_shop/pages/auth.dart';
import 'package:union_shop/pages/sale.dart';
import 'package:union_shop/pages/print_personalisation.dart';
import 'package:union_shop/pages/print_about.dart';
import 'package:union_shop/pages/not_found.dart';

void main() {
  group('Router Tests', () {
    setUp(() {
      // Mock DataService asset loader
      DataService.assetLoader = (String path) async {
        return '''{
  "collections": [
    {
      "id": "test-collection",
      "name": "Test Collection",
      "description": "Test description",
      "imageUrl": "https://example.com/image.jpg"
    },
    {
      "id": "study-essentials",
      "name": "Study Essentials",
      "description": "Essential study items",
      "imageUrl": "https://example.com/study.jpg"
    }
  ],
  "products": [
    {
      "id": "test-product",
      "title": "Test Product",
      "price": "10.00",
      "currency": "£",
      "collectionId": "test-collection",
      "imageUrl": "https://example.com/image.jpg",
      "description": "Test description",
      "inStock": true
    },
    {
      "id": "portsmouth-tshirt",
      "title": "Portsmouth T-Shirt",
      "price": "15.99",
      "currency": "£",
      "collectionId": "study-essentials",
      "imageUrl": "https://example.com/tshirt.jpg",
      "description": "Portsmouth branded t-shirt",
      "inStock": true,
      "sizes": ["S", "M", "L", "XL"],
      "colors": ["Navy", "White"]
    }
  ]
}''';
      };
    });

    tearDown(() {
      DataService.resetInstance();
    });

    testWidgets('router should be configured correctly', (tester) async {
      expect(appRouter, isA<GoRouter>());
      expect(appRouter.routerDelegate, isNotNull);
      expect(appRouter.routeInformationParser, isNotNull);
      expect(appRouter.routeInformationProvider, isNotNull);
    });

    testWidgets('should navigate to home page', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should handle route to /collections', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/collections');
      await tester.pumpAndSettle();

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('should handle route to /about', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/about');
      await tester.pumpAndSettle();

      expect(find.byType(Aboutus), findsOneWidget);
    });

    testWidgets('should handle route to /auth', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/auth');
      await tester.pumpAndSettle();

      expect(find.byType(AuthPage), findsOneWidget);
    });

    testWidgets('should handle route to /sale', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/sale');
      await tester.pumpAndSettle();

      expect(find.byType(SalePage), findsOneWidget);
    });

    testWidgets('should handle route to /print', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/print');
      await tester.pumpAndSettle();

      expect(find.byType(PrintPersonalisationPage), findsOneWidget);
    });

    testWidgets('should handle route to /print/about', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/print/about');
      await tester.pumpAndSettle();

      expect(find.byType(PrintAboutPage), findsOneWidget);
    });

    testWidgets('should handle deep link to product page with ID',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/product/test-product');
      await tester.pumpAndSettle();

      expect(find.byType(ProductPage), findsOneWidget);
    });

    testWidgets('should handle deep link to collection detail with ID',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/collections/test-collection');
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
    });

    testWidgets('should navigate to error page for unknown routes',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/this-route-does-not-exist');
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundPage), findsOneWidget);
    });

    testWidgets('should extract productId from route parameters',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/product/portsmouth-tshirt');
      await tester.pumpAndSettle();

      expect(find.byType(ProductPage), findsOneWidget);
      // Verify the page was created with the correct product ID
      final productPage = tester.widget<ProductPage>(find.byType(ProductPage));
      expect(productPage.productId, equals('portsmouth-tshirt'));
    });

    testWidgets('should extract collectionId from route parameters',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));

      appRouter.go('/collections/study-essentials');
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
      // Verify the page was created with the correct collection ID
      final collectionPage = tester
          .widget<CollectionDetailPage>(find.byType(CollectionDetailPage));
      expect(collectionPage.collectionId, equals('study-essentials'));
    });

    testWidgets(
        'should handle navigation from collections to collection detail',
        (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));
      await tester.pumpAndSettle();

      // Navigate to collection detail
      appRouter.go('/collections/test-collection');
      await tester.pumpAndSettle();

      expect(find.byType(CollectionDetailPage), findsOneWidget);
    });

    testWidgets('should handle navigation to product page', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
      ));
      await tester.pumpAndSettle();

      // Navigate to product
      appRouter.go('/product/test-product');
      await tester.pumpAndSettle();

      expect(find.byType(ProductPage), findsOneWidget);
    });
  });
}
