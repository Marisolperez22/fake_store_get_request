class CartEntity {
  final int? id;
  final int? userId;
  final String? date;
  final List<CartProductsEntity>? products;

  CartEntity({this.id, this.userId, this.date, this.products});
}

class CartProductsEntity {
  final int productId;
  final int quantity;

  CartProductsEntity({required this.productId, required this.quantity});
}
