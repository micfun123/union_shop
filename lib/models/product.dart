class Product {
  final String id;
  final String title;
  final String price;
  final String currency;
  final String collectionId;
  final String imageUrl;
  final String description;
  final bool inStock;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.collectionId,
    required this.imageUrl,
    required this.description,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      currency: json['currency'],
      collectionId: json['collectionId'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      inStock: json['inStock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'currency': currency,
      'collectionId': collectionId,
      'imageUrl': imageUrl,
      'description': description,
      'inStock': inStock,
    };
  }

  String get formattedPrice => '$currency$price';
}
