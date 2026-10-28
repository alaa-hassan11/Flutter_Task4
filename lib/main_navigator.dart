
import 'package:flutter/material.dart';

void main() {
  runApp(const NavigatorApp());
}

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/products': (context) => const ProductsScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/products',
              arguments: 'Guest',
            );
          },
          child: const Text('Login as Guest'),
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username =
        ModalRoute.of(context)!.settings.arguments as String;

    final products = [
      {'name': 'Laptop', 'price': 25000.0},
      {'name': 'Phone', 'price': 12000.0},
      {'name': 'Headphones', 'price': 1500.0},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Products - $username')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product['name'].toString()),
            subtitle: Text('Price: ${product['price']}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                '/details',
                arguments: product,
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Returned result: $result')),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments
            as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              product['name'].toString(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('Price: ${product['price']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  '${product['name']} selected',
                );
              },
              child: const Text('Back and Return Result'),
            ),
          ],
        ),
      ),
    );
  }
}
