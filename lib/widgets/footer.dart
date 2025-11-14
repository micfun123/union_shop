import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const double narrowBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    void placeholder() {
      // Placeholder action for links
    }

    return Container(
      width: double.infinity,
      color: Colors.grey[200], // full-width grey background (edges)
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        // Keep content centered with gutters on large screens
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < narrowBreakpoint;

              if (isNarrow) {
                // Mobile / narrow layout: vertical stacking
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '© 2024 Union Shop. All rights reserved.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        TextButton(onPressed: placeholder, child: const Text('Privacy Policy')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: placeholder, child: const Text('Terms of Service')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Opening Hours:',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    const Text('Mon-Fri: 9am - 4pm', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    const Text('Help and Information:', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('Contact Us', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('FAQs', style: TextStyle(fontSize: 14)),
                  ],
                );
              }

              // Desktop / wide layout: three columns
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: copyright
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '© 2024 Union Shop. All rights reserved.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Middle: policy links
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: placeholder, child: const Text('Privacy Policy')),
                        const SizedBox(width: 16),
                        TextButton(onPressed: placeholder, child: const Text('Terms of Service')),
                      ],
                    ),
                  ),

                  // Right: opening hours / help info
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('Opening Hours:', style: TextStyle(fontSize: 14, color: Colors.black)),
                            SizedBox(height: 4),
                            Text('Mon-Fri: 9am - 4pm', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text('Help and Information:', style: TextStyle(fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Contact Us', style: TextStyle(fontSize: 14)),
                            Text('FAQs', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}