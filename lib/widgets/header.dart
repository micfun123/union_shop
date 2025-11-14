import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  static const double mobileBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    void placeholderCallbackForButtons() {
      // Event handler for buttons that don't do anything yet
    }

    // Helper that shows the mobile nav as a bottom sheet
    void openMobileNav() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                  },
                ),
                ListTile(
                  title: const Text('Shop'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushNamed(context, '/product');
                  },
                ),
                ListTile(
                  title: const Text('The Print Shop'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Replace with real route if you add one
                    Navigator.pushNamed(context, '/product');
                  },
                ),
                ListTile(
                  title: const Text('SALE!'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Placeholder action
                    placeholderCallbackForButtons();
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    placeholderCallbackForButtons();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
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
            'PLACEHOLDER HEADER TEXT',
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
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
                            child: Icon(Icons.image_not_supported, color: Colors.grey),
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
                                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                              },
                              child: const Text('Home'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/product');
                              },
                              child: const Text('Shop'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/product');
                              },
                              child: const Text('The Print Shop'),
                            ),
                            TextButton(
                              onPressed: placeholderCallbackForButtons,
                              child: const Text('SALE!'),
                            ),
                            TextButton(
                              onPressed: placeholderCallbackForButtons,
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
                        icon: const Icon(Icons.search, size: 20, color: Colors.grey),
                        onPressed: placeholderCallbackForButtons,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline, size: 20, color: Colors.grey),
                        onPressed: placeholderCallbackForButtons,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.grey),
                        onPressed: placeholderCallbackForButtons,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),

                      // Mobile hamburger
                      if (isMobile)
                        IconButton(
                          icon: const Icon(Icons.menu, size: 20, color: Colors.grey),
                          onPressed: openMobileNav,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        )
                      else
                        // Desktop keeps the menu icon too (optional)
                        IconButton(
                          icon: const Icon(Icons.menu, size: 20, color: Colors.grey),
                          onPressed: placeholderCallbackForButtons,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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