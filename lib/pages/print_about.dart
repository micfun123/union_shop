import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class PrintAboutPage extends StatelessWidget {
  const PrintAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Print Shack',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                        'Print Shack provides fast, student-friendly print personalisation services. We offer text-based prints on posters, mugs and apparel. This sample about page is connected to the personalisation form and explains available options.',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 16),
                    Text('How it works',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                        'Enter the text you want printed, choose fonts, colour and size. The preview updates in real time. Add to cart to submit your order.',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
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
