import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';

void main() {
  group('Cart model', () {
    test('addItem increases itemCount and uniqueItemCount', () {
      final cart = Cart();
      final cart2 = cart.addItem('p1', 2);

      expect(cart.itemCount, 0);
      expect(cart2.itemCount, 2);
      expect(cart2.uniqueItemCount, 1);

      final cart3 = cart2.addItem('p1', 1);
      expect(cart3.itemCount, 3);
      expect(cart3.uniqueItemCount, 1);

      final cart4 = cart3.addItem('p2', 5, size: 'L', color: 'red');
      expect(cart4.uniqueItemCount, 2);
      expect(cart4.itemCount, 8);
    });

    test('removeItem removes the correct composite key', () {
      var cart = Cart();
      cart = cart.addItem('p1', 1);
      cart = cart.addItem('p2', 2, size: 'M');

      final after = cart.removeItem('p2', size: 'M');
      expect(after.uniqueItemCount, 1);
      expect(after.itemCount, 1);
    });

    test('updateQuantity sets quantity and removes when <= 0', () {
      var cart = Cart();
      cart = cart.addItem('p1', 3);

      final updated = cart.updateQuantity('p1', 5);
      expect(updated.itemCount, 5);

      final removed = updated.updateQuantity('p1', 0);
      expect(removed.isEmpty, true);
    });

    test('totalPrice uses productPrices map correctly', () {
      var cart = Cart();
      cart = cart.addItem('prod-abc', 2);
      cart = cart.addItem('other', 1, size: 'S', color: 'blue');

      final prices = {'prod-abc': 3.5, 'other': 10.0};
      final total = cart.totalPrice(prices);

      // prod-abc: 2 * 3.5 = 7.0, other: 1 * 10.0 = 10.0 => 17.0
      expect(total, closeTo(17.0, 0.0001));
    });

    test('totalPriceUsingResolver calls resolver for each product', () {
      var cart = Cart();
      cart = cart.addItem('p-x', 1);
      cart = cart.addItem('p-y', 2, color: 'red');

      double resolver(String id) {
        if (id == 'p-x') return 4.0;
        if (id == 'p-y') return 2.5;
        return 0.0;
      }

      final total = cart.totalPriceUsingResolver(resolver);
      // p-x: 1*4.0 = 4.0; p-y:2*2.5=5.0 => 9.0
      expect(total, closeTo(9.0, 0.0001));
    });

    test('toJson and fromJson preserve items', () {
      var cart = Cart();
      cart = cart.addItem('p1', 2);
      cart = cart.addItem('p2', 1, size: 'M');

      final json = cart.toJson();
      final restored = Cart.fromJson(json);

      expect(restored.items, cart.items);
    });
  });
}
