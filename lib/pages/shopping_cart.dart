import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/cart_scope.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/data_service.dart';

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
      appBar: AppBar(title: const Text('Cart')),
      body: ValueListenableBuilder<Cart>(
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
              final price = double.tryParse(product?.price ?? '0') ?? 0.0;
              final lineTotal = price * qty;

              final subtitleParts = <String>[];
              if (parsed['size'] != null)
                subtitleParts.add('Size: ${parsed['size']}');
              if (parsed['color'] != null)
                subtitleParts.add('Color: ${parsed['color']}');
              subtitleParts.add('Quantity: $qty');

              return ListTile(
                leading: product != null && product.imageUrl.isNotEmpty
                    ? Image.network(product.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.image))
                    : const Icon(Icons.image),
                title: Text(title),
                subtitle: Text(subtitleParts.join(' • ')),
                trailing: Text('$currency${lineTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}
