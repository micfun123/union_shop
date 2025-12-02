import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/router.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'dart:convert';
import 'dart:async'; // Required for Timer

import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/models/cart_scope.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/services/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  Cart initialCart = Cart();
  final raw = prefs.getString('cart');
  if (raw != null && raw.isNotEmpty) {
    try {
      final Map<String, dynamic> json = jsonDecode(raw);
      initialCart = Cart.fromJson(json);
    } catch (_) {
      // ignore and start with empty cart
      initialCart = Cart();
    }
  }

  final notifier = ValueNotifier<Cart>(initialCart);

  // Save cart to SharedPreferences whenever it changes.
  notifier.addListener(() async {
    try {
      final jsonStr = jsonEncode(notifier.value.toJson());
      await prefs.setString('cart', jsonStr);
    } catch (_) {
      // ignore persistence errors
    }
  });

  runApp(UnionShopApp(cartNotifier: notifier));
}

class UnionShopApp extends StatelessWidget {
  final ValueNotifier<Cart> cartNotifier;

  const UnionShopApp({super.key, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cartNotifier: cartNotifier,
      child: MaterialApp.router(
        title: 'Union Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}

// HomeScreen modified to StatefulWidget for carousel
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Image assets for the carousel
  final List<String> _heroImages = [
    'assets/images/union_shop_hero.jpg',
    'assets/images/union_shop_hero_2.jpg',
    'assets/images/union_shop_hero_3.jpg',
  ];

  // Page controller and timer
  final PageController _pageController = PageController();
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Setup auto-scroll timer to change page every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _heroImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // Animate to the next page
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the timer and controller
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),

            // Hero Section (Now a Carousel)
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background Carousel using PageView
                  Positioned.fill(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _heroImages.length,
                      itemBuilder: (context, index) {
                        final imagePath = _heroImages[index];
                        return Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Positioned.fill(
                    child:
                        Container(color: Colors.black.withValues(alpha: 0.7)),
                  ),

                  // Content overlay
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '2026 Union Shop',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "An exciting new year for the Union Shop.",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => context.go('/collections'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'BROWSE PRODUCTS',
                            style: TextStyle(fontSize: 14, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    FutureBuilder<List<Product>>(
                      future: DataService.instance.getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Failed to load products'));
                        }

                        final products = snapshot.data ?? [];
                        // Show first 6 products as a simple home highlight
                        final display = products.take(6).toList();

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 2 : 1,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 48,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: display.length,
                          itemBuilder: (context, i) {
                            final p = display[i];
                            return ProductCard(
                              id: p.id,
                              title: p.title,
                              price: '${p.currency}${p.price}',
                              imageUrl: p.imageUrl,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/product/$id'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
