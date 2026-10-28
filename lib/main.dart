
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_widgets.dart';

// Assignment answers:
// StatefulWidget preserves mutable state during the widget lifetime.
// initState runs once when the State object is created.
// didChangeDependencies runs when inherited dependencies change.
// build creates the widget UI.
// deactivate runs when the widget is removed from the tree.
// dispose releases resources when the State object is permanently removed.
// setState tells Flutter to rebuild the UI after state changes.
// MediaQuery provides screen information such as width.
// ListView is suitable for narrow screens; GridView for wider screens.
// Navigator.pushNamed uses named routes and can return a result with pop.
// go_router supports named routes, path parameters, and query parameters.
// context.go replaces the current route; context.push adds a route.
// context.pop(result) returns a result to the previous route.

void main() {
  runApp(const ProductsApp());
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final user = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsScreen(username: user);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Product';
        final price =
            double.tryParse(state.pathParameters['price'] ?? '') ?? 0;
        return DetailsScreen(name: name, price: price);
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('LoginScreen: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('LoginScreen: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginScreen: build');

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed(
              'products',
              queryParameters: {'user': 'Guest'},
            );
          },
          child: const Text('Login as Guest'),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('LoginScreen: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('LoginScreen: dispose');
    super.dispose();
  }
}

class ProductsScreen extends StatefulWidget {
  final String username;

  const ProductsScreen({super.key, required this.username});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int favorites = 0;
  double screenWidth = 0;

  final List<Map<String, dynamic>> products = [
    {'name': 'Laptop', 'price': 25000.0},
    {'name': 'Phone', 'price': 12000.0},
    {'name': 'Headphones', 'price': 1500.0},
    {'name': 'Keyboard', 'price': 900.0},
    {'name': 'Mouse', 'price': 500.0},
    {'name': 'Monitor', 'price': 7000.0},
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('ProductsScreen: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    debugPrint('ProductsScreen: didChangeDependencies');
    debugPrint('Screen width: $screenWidth');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProductsScreen: build');

    final isWide = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products - ${widget.username}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: Text('Favorites: $favorites')),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Screen width: ${screenWidth.toStringAsFixed(0)} px'),
          ),
          Expanded(
            child: isWide
                ? ProductsGridView(
                    products: products,
                    onProductTap: openDetails,
                    onFavorite: addFavorite,
                  )
                : ProductsListView(
                    products: products,
                    onProductTap: openDetails,
                    onFavorite: addFavorite,
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
    final result = await context.pushNamed<String>(
      'details',
      pathParameters: {
        'name': product['name'].toString(),
        'price': product['price'].toString(),
      },
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Result: $result')),
      );
    }
  }

  @override
  void deactivate() {
    debugPrint('ProductsScreen: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('ProductsScreen: dispose');
    super.dispose();
  }
}

class DetailsScreen extends StatefulWidget {
  final String name;
  final double price;

  const DetailsScreen({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('DetailsScreen: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('DetailsScreen: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DetailsScreen: build');

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
              'Price: ${widget.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pop('${widget.name} selected');
              },
              child: const Text('Back and Return Result'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('DetailsScreen: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('DetailsScreen: dispose');
    super.dispose();
  }
}
