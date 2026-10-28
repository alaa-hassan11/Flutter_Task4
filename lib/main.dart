import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_widgets.dart';

void main() {
  runApp(const ProductsApp());
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final user = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: user);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Product';
        final price = int.tryParse(state.pathParameters['price'] ?? '') ?? 0;
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class ProductsApp extends StatelessWidget {
  const ProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Products Task',
      routerConfig: appRouter,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print('LoginPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('LoginPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(
              'products',
              queryParameters: {'user': 'Guest'},
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('LoginPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('LoginPage: dispose');
    super.dispose();
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0;
  double screenWidth = 0;
  String? cartMessage;

  final List<Map<String, dynamic>> products = [
    {'name': 'Laptop', 'price': 25000},
    {'name': 'Phone', 'price': 12000},
    {'name': 'Headphones', 'price': 1500},
    {'name': 'Keyboard', 'price': 900},
    {'name': 'Mouse', 'price': 500},
    {'name': 'Monitor', 'price': 7000},
  ];

  @override
  void initState() {
    super.initState();
    print('ProductsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    print(
      'ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}',
    );
    screenWidth = size.width;
  }

  @override
  Widget build(BuildContext context) {
    print('ProductsPage: build');

    final isWide = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Favorites: $favorites',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Screen width: ${screenWidth.toStringAsFixed(0)} px',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          if (cartMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cartMessage!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isWide
                ? ProductsGridView(
                    products: products,
                    onFavoritePressed: addFavorite,
                    onProductTap: (index) => openDetails(products[index]),
                  )
                : ProductsListView(
                    products: products,
                    onFavoritePressed: addFavorite,
                    onProductTap: (index) => openDetails(products[index]),
                  ),
          ),
        ],
      ),
    );
  }

  void addFavorite() {
    setState(() {
      favorites++;
    });
  }

  Future<void> openDetails(Map<String, dynamic> product) async {
    final result = await context.push<String>(
      '/details/${product['name']}/${product['price']}',
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        cartMessage = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  void deactivate() {
    print('ProductsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('ProductsPage: dispose');
    super.dispose();
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final int price;

  const DetailsPage({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print('DetailsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('DetailsPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('DetailsPage: build');

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Price: \$${widget.price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.pop('${widget.name} added to cart');
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('DetailsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('DetailsPage: dispose');
    super.dispose();
  }
}
