class Cart {
  // Map of "productId-size-color" to quantity
  final Map<String, int> items;

  Cart({Map<String, int>? items}) : items = items ?? {};

  // Generate key for cart item
  static String _key(String productId, {String? size, String? color}) {
    return '$productId-${size ?? 'none'}-${color ?? 'none'}';
  }

  // Get total number of items
  int get itemCount => items.values.fold(0, (sum, qty) => sum + qty);

  // Get number of unique items
  int get uniqueItemCount => items.length;

  // Check if empty
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  // Add or update item
  Cart addItem(String productId, int quantity, {String? size, String? color}) {
    final key = _key(productId, size: size, color: color);
    final newItems = Map<String, int>.from(items);
    newItems[key] = (newItems[key] ?? 0) + quantity;
    return Cart(items: newItems);
  }

  // Remove item
  Cart removeItem(String productId, {String? size, String? color}) {
    final key = _key(productId, size: size, color: color);
    final newItems = Map<String, int>.from(items);
    newItems.remove(key);
    return Cart(items: newItems);
  }

  // Update quantity
  Cart updateQuantity(String productId, int quantity,
      {String? size, String? color}) {
    if (quantity <= 0) {
      return removeItem(productId, size: size, color: color);
    }
    final key = _key(productId, size: size, color: color);
    final newItems = Map<String, int>.from(items);
    newItems[key] = quantity;
    return Cart(items: newItems);
  }

  // Clear cart
  Cart clear() => Cart(items: {});

  // Total price
  // Calculate total price given a mapping of productId -> price (double).
  // The cart stores keys in the format: "productId-size-color" (where size/color may be 'none').
  double totalPrice(Map<String, double> productPrices) {
    double total = 0.0;
    items.forEach((key, qty) {
      final productId = _productIdFromKey(key);
      final price = productPrices[productId] ?? 0.0;
      total += price * qty;
    });
    return total;
  }

  // Calculate total price using a resolver function that maps productId -> price (double).
  // This is useful when you have Product objects available and want to compute totals
  // without constructing a separate map.
  double totalPriceUsingResolver(double Function(String productId) resolver) {
    double total = 0.0;
    items.forEach((key, qty) {
      final productId = _productIdFromKey(key);
      final price = resolver(productId);
      total += price * qty;
    });
    return total;
  }

  // Internal helper to extract the productId from the composite key.
  static String _productIdFromKey(String key) {
    // The key format is '<productId>-<size>-<color>'. Product IDs themselves
    // may contain dashes, so find the second-to-last '-' and take everything
    // before it as the productId.
    final last = key.lastIndexOf('-');
    final secondLast = key.lastIndexOf('-', last - 1);
    if (secondLast <= 0) return key;
    return key.substring(0, secondLast);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {'items': items};

  // Create from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(items: Map<String, int>.from(json['items'] as Map));
  }
}
