import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/collection.dart';
import 'package:union_shop/services/data_service.dart';

class CollectionDetailPage extends StatefulWidget {
  final String collectionId;

  const CollectionDetailPage({super.key, required this.collectionId});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  Collection? collection;
  List<Product> products = [];
  bool isLoading = true;
  String sortBy = 'Popular';
  String priceRange = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedCollection =
          await DataService.instance.getCollection(widget.collectionId);
      final loadedProducts = await DataService.instance
          .getProductsByCollection(widget.collectionId);

      setState(() {
        collection = loadedCollection;
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Product> get filteredAndSortedProducts {
    List<Product> filtered = products;

    // Apply price filter
    if (priceRange != 'All') {
      filtered = filtered.where((product) {
        final price = double.tryParse(product.price) ?? 0;
        switch (priceRange) {
          case 'Under £5':
            return price < 5;
          case '£5 - £10':
            return price >= 5 && price <= 10;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => (double.tryParse(a.price) ?? 0)
            .compareTo(double.tryParse(b.price) ?? 0));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => (double.tryParse(b.price) ?? 0)
            .compareTo(double.tryParse(a.price) ?? 0));
        break;
      default: // Popular
        // Keep original order for now
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Column(
          children: [
            const AppHeader(),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const AppFooter(),
          ],
        ),
      );
    }

    if (collection == null) {
      return Scaffold(
        body: Column(
          children: [
            const AppHeader(),
            const Expanded(
              child: Center(
                child: Text('Collection not found'),
              ),
            ),
            const AppFooter(),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Collection title
                    Text(
                      collection!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      collection!.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Filters and sorting
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            value: sortBy,
                            items: const [
                              DropdownMenuItem(
                                value: 'Popular',
                                child: Text('Popular'),
                              ),
                              DropdownMenuItem(
                                value: 'Price: Low to High',
                                child: Text('Price: Low to High'),
                              ),
                              DropdownMenuItem(
                                value: 'Price: High to Low',
                                child: Text('Price: High to Low'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                sortBy = value!;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Sort by'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            value: priceRange,
                            items: const [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: 'Under £5',
                                child: Text('Under £5'),
                              ),
                              DropdownMenuItem(
                                value: '£5 - £10',
                                child: Text('£5 - £10'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                priceRange = value!;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: 'Price range'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Products grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: filteredAndSortedProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredAndSortedProducts[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              context.go('/product/${product.id}');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported,
                                              color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        product.formattedPrice,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pagination controls (placeholder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Prev')),
                        const SizedBox(width: 8),
                        OutlinedButton(
                            onPressed: () {}, child: const Text('1')),
                        const SizedBox(width: 8),
                        OutlinedButton(
                            onPressed: () {}, child: const Text('2')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: const Text('Next')),
                      ],
                    ),

                    const SizedBox(height: 24),
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
