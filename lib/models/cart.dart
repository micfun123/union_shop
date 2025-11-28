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

  // Convert to JSON
  Map<String, dynamic> toJson() => {'items': items};

  // Create from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(items: Map<String, int>.from(json['items'] as Map));
  }
}
