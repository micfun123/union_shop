import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_scope.dart';
import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/pages/shopping_cart.dart';

void main() {
  const sampleJson = {
    'products': [
      {
        'id': 'prod-1',
        'title': 'Product One',
        'price': '3.50',
        'currency': '£',
        'collectionId': 'c1',
        'imageUrl': '',
        'description': 'First product',
        'inStock': true,
      },
      {
        'id': 'prod-2-dashed',
        'title': 'Dashed Product',
        'price': '5.00',
        'currency': '£',
        'collectionId': 'c1',
        'imageUrl': '',
        'description': 'Second product',
        'inStock': true,
      }
    ],
    'collections': []
  };

  setUp(() {
    // Ensure DataService uses our in-memory JSON and fresh instance
    DataService.resetInstance();
    DataService.assetLoader = (String path) async => json.encode(sampleJson);
  });

  tearDown(() {
    DataService.resetInstance();
  });

  testWidgets('shows empty cart message when cart is empty',
      (WidgetTester tester) async {
    // Provide larger layout constraints via MediaQuery to avoid deprecated
    // window test APIs and to prevent layout overflow in ListTile.
    final notifier = ValueNotifier<Cart>(Cart());

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(1200, 1600), devicePixelRatio: 1.0),
      child: MaterialApp(
        home:
            CartScope(cartNotifier: notifier, child: const ShoppingCartPage()),
      ),
    ));

    // Wait for async product load
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('displays items, updates quantity and removes item',
      (WidgetTester tester) async {
    // Provide larger layout constraints via MediaQuery to avoid deprecated
    // window test APIs and to prevent layout overflow in ListTile.
    final notifier = ValueNotifier<Cart>(Cart().addItem('prod-1', 2));

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(1200, 1600), devicePixelRatio: 1.0),
      child: MaterialApp(
        home:
            CartScope(cartNotifier: notifier, child: const ShoppingCartPage()),
      ),
    ));

    await tester.pumpAndSettle();

    // Product title should be shown
    expect(find.text('Product One'), findsOneWidget);

    // Quantity shown
    expect(find.text('2'), findsOneWidget);

    // Increase quantity
    final increase = find.widgetWithIcon(IconButton, Icons.add_circle_outline);
    expect(increase, findsOneWidget);
    // Call the onPressed directly to avoid hit-test issues in tests
    final IconButton incWidget = tester.widget<IconButton>(increase);
    incWidget.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);

    // Decrease quantity
    final decrease =
        find.widgetWithIcon(IconButton, Icons.remove_circle_outline);
    expect(decrease, findsOneWidget);
    final IconButton decWidget = tester.widget<IconButton>(decrease);
    decWidget.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);

    // Remove using delete button
    final remove = find.widgetWithIcon(IconButton, Icons.delete_outline);
    expect(remove, findsOneWidget);
    final IconButton remWidget = tester.widget<IconButton>(remove);
    remWidget.onPressed!();
    await tester.pumpAndSettle();

    // After removal, cart should be empty
    expect(find.text('Your cart is empty'), findsOneWidget);
    // SnackBar is shown confirming removal
    expect(find.text('Item removed from cart'), findsOneWidget);
  });

  testWidgets('handles product ids with dashes correctly',
      (WidgetTester tester) async {
    // Provide larger layout constraints via MediaQuery to avoid deprecated
    // window test APIs and to prevent layout overflow in ListTile.
    // Key parsing should still match product id that contains dashes
    final notifier = ValueNotifier<Cart>(
        Cart().addItem('prod-2-dashed', 1, size: 'M', color: 'red'));

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(1200, 1600), devicePixelRatio: 1.0),
      child: MaterialApp(
        home:
            CartScope(cartNotifier: notifier, child: const ShoppingCartPage()),
      ),
    ));

    await tester.pumpAndSettle();

    // The title for the dashed product should appear
    expect(find.text('Dashed Product'), findsOneWidget);
  });
}
