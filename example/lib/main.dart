import 'package:fake_store_get_request/fake_store_get_request.dart';
import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FakeStoreApp());
}

class FakeStoreApp extends StatelessWidget {
  const FakeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store Example',
      home: const ProductScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductScreen> {
  final service = FakeStoreService();
  late Future<List<Product>> _productsFuture;
  late Future<List<String>> _getCategories;


  @override
  void initState() {
    super.initState();
    _productsFuture = service.getProducts();
    _getCategories = service.getCategories();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text((product.rating?.rate ?? 0).toString()),
                // leading: Image.network(product.image ?? '', width: 50, height: 50),
                // subtitle: Text('\$${(product.price ?? 0).toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
