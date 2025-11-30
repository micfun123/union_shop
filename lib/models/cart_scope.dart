import 'package:flutter/widgets.dart';
import 'package:union_shop/models/cart.dart';

/// Lightweight provider for a mutable cart instance using [ValueNotifier].
///
/// Use `CartScope.of(context)` to get the `ValueNotifier<Cart>` and
/// read or update the cart with `cartScope.value` / `cartScope.value = ...`.
class CartScope extends InheritedWidget {
  final ValueNotifier<Cart> cartNotifier;

  const CartScope({
    required this.cartNotifier,
    required super.child,
    super.key,
  });

  static ValueNotifier<Cart> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    //print the item count in the cart for debugging
    if (scope == null) {
      throw StateError('No CartScope found in context');
    }
    return scope.cartNotifier;
  }

  @override
  bool updateShouldNotify(covariant CartScope oldWidget) {
    return cartNotifier != oldWidget.cartNotifier;
  }
}
