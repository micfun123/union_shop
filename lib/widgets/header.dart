import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  static const double mobileBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    void placeholderCallbackForButtons() {
      // Event handler for buttons that don't do anything yet
    }

    Future<void> openMobileNav() async {
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      const double top = kToolbarHeight + 8;
      final RelativeRect position = RelativeRect.fromLTRB(
        overlay.size.width - 200, // left
        top, // top
        16, // right
        0, // bottom
      );

      final String? selected = await showMenu<String>(
        context: context,
        position: position,
        items: <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'home', child: Text('Home')),
          const PopupMenuItem<String>(
              value: 'collections', child: Text('Collections')),
          const PopupMenuItem<String>(
              value: 'print', child: Text('The Print Shop')),
          const PopupMenuItem<String>(value: 'sale', child: Text('SALE!')),
          const PopupMenuItem<String>(value: 'about', child: Text('About')),
        ],
      );

      if (selected == null) return;

      switch (selected) {
        case 'home':
          context.go('/');
          break;
        case 'collections':
          context.go('/collections');
          break;
        case 'print':
          // For now, just navigate to collections
          context.go('/collections');
          break;
        case 'sale':
          context.go('/sale');
          break;
        case 'about':
          context.go('/about');
          break;
      }
    }

    // Main header structure: top banner + responsive main bar
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: const Color(0xFF4d2963),
          child: const Text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        // Main header bar (responsive)
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < mobileBreakpoint;

            return Container(
              height: 64,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo (left)
                  GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: Image.network(
                      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          width: 28,
                          height: 28,
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Center nav (desktop) or spacer (mobile)
                  if (!isMobile)
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.go('/');
                              },
                              child: const Text('Home'),
                            ),
                            // Shop button navigates to collections
                            TextButton(
                              onPressed: () {
                                context.go('/collections');
                              },
                              child: const Text('Shop'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/collections');
                              },
                              child: const Text('The Print Shop'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/sale');
                              },
                              child: const Text('SALE!'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/about');
                              },
                              child: const Text('About'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Spacer(), // push icons/menu to the right on mobile

                  // Icon buttons (right). On mobile, include a hamburger menu.
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search,
                            size: 20, color: Colors.grey),
                        onPressed: placeholderCallbackForButtons,
                        padding: const EdgeInsets.all(8),
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline,
                            size: 20, color: Colors.grey),
                        onPressed: () {
                          context.go('/auth');
                        },
                        padding: const EdgeInsets.all(8),
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined,
                            size: 20, color: Colors.grey),
                        onPressed: placeholderCallbackForButtons,
                        padding: const EdgeInsets.all(8),
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),

                      // Mobile hamburger - uses showMenu
                      if (isMobile)
                        IconButton(
                          icon: const Icon(Icons.menu,
                              size: 20, color: Colors.grey),
                          onPressed: openMobileNav,
                          padding: const EdgeInsets.all(8),
                          constraints:
                              const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
