import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/services/data_service.dart';
import 'package:union_shop/models/product.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({super.key, this.initialQuery = ''});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Product> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(q);
    });
  }

  Future<void> _performSearch(String q) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await DataService.instance.searchProducts(q);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
    }
  }

  Widget _buildProductCard(Product p) {
    return GestureDetector(
      onTap: () => context.go('/product/${p.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: p.imageUrl.startsWith('assets/')
                ? Image.asset(
                    p.imageUrl,
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
                    p.imageUrl,
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
                p.title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                p.formattedPrice,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search Products',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Search product titles and descriptions.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      onChanged: (v) {
                        // update query param in URL for shareability
                        if (v.isEmpty) {
                          context.go('/search');
                        } else {
                          // keep other query params empty
                          context.go('/search?q=${Uri.encodeComponent(v)}');
                        }
                        _onQueryChanged(v);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text('No results'),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 800
                                  ? 3
                                  : (MediaQuery.of(context).size.width > 600
                                      ? 2
                                      : 1),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, i) => _buildProductCard(_results[i]),
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
