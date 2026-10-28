
import 'package:flutter/material.dart';

typedef ProductTap = Future<void> Function(
  Map<String, dynamic> product,
);

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final ProductTap onProductTap;
  final VoidCallback onFavorite;

  const ProductsListView({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: ListTile(
            title: Text(product['name'].toString()),
            subtitle: Text('Price: ${product['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: onFavorite,
            ),
            onTap: () => onProductTap(product),
          ),
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final ProductTap onProductTap;
  final VoidCallback onFavorite;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          child: InkWell(
            onTap: () => onProductTap(product),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['name'].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Price: ${product['price']}'),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: onFavorite,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
