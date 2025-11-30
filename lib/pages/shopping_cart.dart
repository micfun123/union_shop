import 'package:flutter/material.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AppHeader(),
            SizedBox(height: 200, child: Center(child: Text('Shopping Cart'))),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}
