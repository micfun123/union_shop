import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_scope.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Map<String, Product> _products = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final svc = DataService.instance;
    final list = await svc.getProducts();
    final map = <String, Product>{};
    for (final p in list) {
      map[p.id] = p;
    }
    setState(() {
      _products = map;
      _loading = false;
    });
  }

  Map<String, String?> _parseKey(String key) {
    final last = key.lastIndexOf('-');
    final secondLast = key.lastIndexOf('-', last - 1);
    if (secondLast <= 0 || last <= 0) {
      return {'productId': key, 'size': null, 'color': null};
    }
    final productId = key.substring(0, secondLast);
    final sizePart = key.substring(secondLast + 1, last);
    final colorPart = key.substring(last + 1);
    return {
      'productId': productId,
      'size': sizePart != 'none' ? sizePart : null,
      'color': colorPart != 'none' ? colorPart : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cartNotifier = CartScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),

            // Scrollable List
            Expanded(
              child: ValueListenableBuilder<Cart>(
                valueListenable: cartNotifier,
                builder: (context, cart, _) {
                  if (cart.isEmpty) {
                    return const Center(child: Text('Your cart is empty'));
                  }

                  final entries = cart.items.entries.toList();

                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      final key = e.key;
                      final qty = e.value;
                      final parsed = _parseKey(key);
                      final productId = parsed['productId'] ?? key;
                      final product = _products[productId];

                      final title = product?.title ?? productId;
                      final currency = product?.currency ?? '£';
                      final price =
                          double.tryParse(product?.price ?? '0') ?? 0.0;
                      final lineTotal = price * qty;

                      final subtitleParts = <String>[];
                      if (parsed['size'] != null) {
                        subtitleParts.add('Size: ${parsed['size']}');
                      }
                      if (parsed['color'] != null) {
                        subtitleParts.add('Color: ${parsed['color']}');
                      }
                      subtitleParts.add('Quantity: $qty');

                      return ListTile(
                        leading: product != null && product.imageUrl.isNotEmpty
                            ? Image.network(product.imageUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.image))
                            : const Icon(Icons.image),
                        title: Text(title),
                        subtitle: Text(subtitleParts.join(' • ')),
                        trailing: SizedBox(
                          width: 160,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Decrease quantity
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      onPressed: () {
                                        if (qty - 1 <= 0) {
                                          cartNotifier.value =
                                              cartNotifier.value.removeItem(
                                            productId,
                                            size: parsed['size'],
                                            color: parsed['color'],
                                          );
                                        } else {
                                          cartNotifier.value =
                                              cartNotifier.value.updateQuantity(
                                            productId,
                                            qty - 1,
                                            size: parsed['size'],
                                            color: parsed['color'],
                                          );
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                          minWidth: 28, minHeight: 28),
                                      iconSize: 20,
                                      visualDensity: VisualDensity.compact,
                                      tooltip: 'Decrease quantity',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: Text('$qty',
                                          style: const TextStyle(fontSize: 14)),
                                    ),
                                    // Increase quantity
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        cartNotifier.value =
                                            cartNotifier.value.updateQuantity(
                                          productId,
                                          qty + 1,
                                          size: parsed['size'],
                                          color: parsed['color'],
                                        );
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                          minWidth: 28, minHeight: 28),
                                      iconSize: 20,
                                      visualDensity: VisualDensity.compact,
                                      tooltip: 'Increase quantity',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        '$currency${lineTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () {
                                        cartNotifier.value =
                                            cartNotifier.value.removeItem(
                                          productId,
                                          size: parsed['size'],
                                          color: parsed['color'],
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Item removed from cart')),
                                        );
                                      },
                                      tooltip: 'Remove',
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                          minWidth: 24, minHeight: 24),
                                      iconSize: 20,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Subtotal and checkout row
            ValueListenableBuilder<Cart>(
              valueListenable: cartNotifier,
              builder: (context, cart, _) {
                if (cart.isEmpty) return const SizedBox.shrink();

                // Build price map from loaded products
                final productPrices = <String, double>{};
                _products.forEach((id, p) {
                  productPrices[id] = double.tryParse(p.price) ?? 0.0;
                });

                final subtotal = cart.totalPrice(productPrices);
                final currency = _products.values.isNotEmpty
                    ? _products.values.first.currency
                    : '£';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Subtotal',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700])),
                            const SizedBox(height: 4),
                            Text('$currency${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Placeholder checkout action
                          },
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
