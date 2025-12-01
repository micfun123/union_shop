# Union Shop — Coursework Project

This repository contains a Flutter implementation of a small e-commerce site used for coursework and demonstrations. The app demonstrates routing, UI layout, model-driven pages, a simple cart, basic persistence, and tests. This README explains what the project is, how to set it up, how to use it, key features, and a detailed explanation of the file/folder layout.

Table of contents
- What this is
- Quick setup
- How to run & test
- Key features
- Detailed file / folder explanation
- Development tips
- Extending the project
- Submission checklist

---

What this is
------------

- A Flutter app (web-first) that recreates a small on-campus shop interface.
- Uses a local JSON file (`assets/data/products.json`) as the data source (via `DataService`).
- Demonstrates navigation with `go_router`, simple state (cart) via `ValueNotifier` wrapped in `CartScope`, and widget/unit tests.

Quick setup
-----------

Prerequisites
- Flutter SDK (stable). Verify with `flutter doctor`.
- Git (to clone the repo).
- Chrome (recommended) for web target.

Install dependencies

```bash
flutter pub get
```

Run the app (web)

```bash
flutter run -d chrome
```

Run tests

```bash
flutter test
```

How to use the app (brief)
-------------------------

- Home: shows hero and product highlights. Click `BROWSE PRODUCTS` to see collections.
- Collections: lists product collections. Click a collection to view products.
- Product page: shows product details, price, size options and an Add to Cart button.
- Cart: shows items in the cart; change quantities or remove items. Cart persists using `SharedPreferences`.
- Search: minimal client-side search is available (if implemented). Header and footer can trigger search.

Key features
------------

- Routing: `go_router` for declarative routes including deep links: `/product/:productId`, `/collections/:collectionId`.
- Data service: `lib/services/data_service.dart` loads `assets/data/products.json` and exposes product/collection queries.
- Cart: model in `lib/models/cart.dart` and `CartScope` to provide a `ValueNotifier<Cart>` throughout the app. Cart supports add/update/remove and price calculations.
- Persistence: `main()` stores cart JSON in `SharedPreferences` so items persist between runs.
- Tests: widget and unit tests under `test/` that stub `DataService` for deterministic data.

Detailed file / folder explanation
---------------------------------

Top-level
- `pubspec.yaml` — project metadata and dependencies (run `flutter pub get` after edits).
- `assets/` — contains `data/products.json` and images used by the app.

`lib/` (application source)
- `main.dart` — app entry point. Initializes `Cart` persistence, sets up `CartScope`, and contains `HomeScreen` and `ProductCard` UI used on the homepage.
- `router.dart` — defines `GoRouter` routes and page builders.
- `product_page.dart` — full product detail view; reads `productId` from route and displays product info.

`lib/models/`
- `product.dart` — `Product` model with `fromJson`/`toJson` and helpers.
- `collection.dart` — `Collection` model.
- `cart.dart` — `Cart` model containing composite-key map of items to quantity, price calculations, serialization.
- `cart_scope.dart` — `InheritedWidget` wrapper exposing a `ValueNotifier<Cart>` for app-wide cart access.

`lib/pages/`
- `collections.dart` — page listing collections; uses `DataService.getCollections()`.
- `collection_detail.dart` — shows products for a specific collection; supports sort/filter and pagination controls (URL query params supported).
- `shopping_cart.dart` — cart page UI; reads `CartScope` and renders items with quantity controls and remove action.
- other pages: `aboutus.dart`, `auth.dart`, `sale.dart`, `print_personalisation.dart`, `print_about.dart`, `not_found.dart`.

`lib/services/`
- `data_service.dart` — singleton service that loads and caches JSON data. Tests override `DataService.assetLoader` to provide deterministic content instead of reading assets.

`lib/widgets/`
- `header.dart` — top navigation header with logo, nav links, and action icons (search/account/cart).
- `footer.dart` — footer with links and a compact search trigger.

`test/`
- Widget and unit tests. Examples:
  - `test/home_test.dart` — homepage widget tests (overrides `DataService.assetLoader` for fixtures).
  - `test/cart_test.dart` — unit tests for `Cart` model.
  - `test/shopping_cart_test.dart` — widget tests for the cart page.

Development tips
----------------

- Tests: override `DataService.assetLoader` in `setUp()` to return JSON fixtures. This is more reliable than mocking the asset method channel.
- Responsive testing: wrap widgets in `MediaQuery` during widget tests to simulate different screen sizes instead of modifying test window internals (deprecated APIs).
- Use `tester.pumpAndSettle()` with care; sometimes limited pump loops reduce hangs from network/image futures.

