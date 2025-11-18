import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  static const List<_Collection> _collections = [
    _Collection(
      title: 'Study Essentials',
      description: 'Notebooks, pens and must-have stationery items.',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      productCount: 8,
    ),
    _Collection(
      title: 'Apparel',
      description: 'T-shirts, hoodies and hats to show your colours.',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
      productCount: 12,
    ),
    _Collection(
      title: 'Gifts & Home',
      description: 'Mugs, prints and homeware perfect for presents.',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      productCount: 6,
    ),
  ];

  void _openCollection(BuildContext context, _Collection coll) {
    // Placeholder: navigate to product list / collection view.
    // For now we reuse /product as a demo target.
    Navigator.pushNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    // If navigation passed a specific collection name as an argument, pick it up here.
    final Object? arg = ModalRoute.of(context)?.settings.arguments;
    final String? selectedCollection = arg is String ? arg : null;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Collections',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    if (selectedCollection != null) ...[
                      const SizedBox(height: 8),
                      Text('Showing: $selectedCollection', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                    const SizedBox(height: 8),
                    const Text(
                      'Browse curated collections of products. Tap a collection to view items.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Collections grid
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _collections.map((c) => _CollectionCard(collection: c, onTap: () => _openCollection(context, c))).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _Collection {
  final String title;
  final String description;
  final String imageUrl;
  final int productCount;

  const _Collection({required this.title, required this.description, required this.imageUrl, required this.productCount});
}

class _CollectionCard extends StatelessWidget {
  final _Collection collection;
  final VoidCallback onTap;

  const _CollectionCard({required this.collection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(collection.imageUrl, fit: BoxFit.cover, errorBuilder: (context, e, st) => Container(color: Colors.grey[300])),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(collection.description, style: const TextStyle(fontSize: 14, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text('${collection.productCount} items', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
