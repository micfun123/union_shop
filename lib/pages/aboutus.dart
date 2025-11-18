import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(),
            // About Us Content
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to Union Shop! We are dedicated to providing high-quality products that support our community. Our mission is to offer a wide range of items that cater to the needs and interests of our customers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'At Union Shop, we believe in fair trade and ethical sourcing. We work closely with local artisans and suppliers to ensure that every product we sell meets our standards for quality and sustainability.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Thank you for choosing Union Shop. We look forward to serving you and being a part of your community!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}

