import 'package:fake_store_get_request/fake_store_get_request.dart';
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
  late Future<Product> _getProductdDetail;

  @override
  void initState() {
    super.initState();
    _productsFuture = service.getProducts();
    _getCategories = service.getCategories();
    _getProductdDetail = service.getProductDetail(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<Product>(
        future: _getProductdDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return Text(products.title ?? 'Hola');
          // return ListView.builder(
          //   itemCount: products.length,
          //   itemBuilder: (context, index) {
          //     final product = products[index];
          //     return ListTile(title: Text((product.title ?? '').toString()));
          //   },
          // );
        },
      ),
    );
  }
}
