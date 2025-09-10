import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
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
  // late Future<List<Product>> _productsFuture;
  // late Future<List<String>> _getCategories;
  // late Future<Product> _getProductdDetail;
  // late Future<LoginResponse> _login;
  late Future<Cart> _getUserCart;



  @override
  void initState() {
    super.initState();
    // _productsFuture = service.getProductByCategory('electronics');
    // _getCategories = service.getCategories();
    // _login = service.login('mor_2314', '83r5^_');
    // _getProductdDetail = service.getProductDetail(1);
    _getUserCart = service.getUserCart(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<Cart>(
        future: _getUserCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!;
          return Text((products.products?[0].productId).toString());
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


