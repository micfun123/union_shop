import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  static const List<_SaleProduct> _saleProducts = [
    _SaleProduct(
      title: 'Portsmouth City Magnet',
      originalPrice: '£5.99',
      salePrice: '£3.99',
      discount: '33% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ),
    _SaleProduct(
      title: 'University Notebook Set',
      originalPrice: '£12.99',
      salePrice: '£8.99',
      discount: '31% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ),
    _SaleProduct(
      title: 'UPSU Hoodie',
      originalPrice: '£34.99',
      salePrice: '£24.99',
      discount: '29% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
    ),
    _SaleProduct(
      title: 'Portsmouth Postcard Pack',
      originalPrice: '£4.99',
      salePrice: '£2.99',
      discount: '40% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    ),
    _SaleProduct(
      title: 'Student Essentials Bundle',
      originalPrice: '£19.99',
      salePrice: '£14.99',
      discount: '25% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    ),
    _SaleProduct(
      title: 'University Mug',
      originalPrice: '£8.99',
      salePrice: '£5.99',
      discount: '33% OFF',
      imageUrl: 'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),

            // Promotional banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4d2963),
                    const Color(0xFF4d2963).withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.local_offer, size: 48, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      'MASSIVE SALE!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save up to 40% on selected items',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIMITED TIME ONLY',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sale products section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Sale Items',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_saleProducts.length} items',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Grab these deals while stocks last!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Products grid
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 900
                          ? 3
                          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.75,
                      children: _saleProducts
                          .map((p) => _SaleProductCard(product: p))
                          .toList(),
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

class _SaleProduct {
  final String title;
  final String originalPrice;
  final String salePrice;
  final String discount;
  final String imageUrl;

  const _SaleProduct({
    required this.title,
    required this.originalPrice,
    required this.salePrice,
    required this.discount,
    required this.imageUrl,
  });
}

class _SaleProductCard extends StatelessWidget {
  final _SaleProduct product;

  const _SaleProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with discount badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, st) =>
                        Container(color: Colors.grey[300]),
                  ),
                  // Discount badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.discount,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        product.originalPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.salePrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
