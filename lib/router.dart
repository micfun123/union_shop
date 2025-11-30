import 'package:go_router/go_router.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/pages/aboutus.dart';
import 'package:union_shop/pages/print_personalisation.dart';
import 'package:union_shop/pages/print_about.dart';
import 'package:union_shop/pages/not_found.dart';
import 'package:union_shop/pages/collections.dart';
import 'package:union_shop/pages/collection_detail.dart';
import 'package:union_shop/pages/auth.dart';
import 'package:union_shop/pages/sale.dart';
import 'package:union_shop/pages/shopping_cart.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/collections',
      builder: (context, state) => const CollectionsPage(),
    ),
    GoRoute(
      path: '/collections/:collectionId',
      builder: (context, state) {
        final collectionId = state.pathParameters['collectionId']!;
        return CollectionDetailPage(collectionId: collectionId);
      },
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/print',
      builder: (context, state) => const PrintPersonalisationPage(),
    ),
    GoRoute(
      path: '/print/about',
      builder: (context, state) => const PrintAboutPage(),
    ),
    GoRoute(
      path: '/sale',
      builder: (context, state) => const SalePage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const Aboutus(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const ShoppingCartPage(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
