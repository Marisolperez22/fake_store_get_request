import '../../domain/entities/cart_entity.dart';

class Cart extends CartEntity {
  Cart({super.date, super.id, super.userId, super.products});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    userId: json["userId"],
    date: json["date"],
    products:
        (json["products"] as List)
            .map((item) => CartProducts.fromJson(item))
            .toList(),
  );
}

class CartProducts extends CartProductsEntity {
  CartProducts({required super.productId, required super.quantity});

  factory CartProducts.fromJson(Map<String, dynamic> json) =>
      CartProducts(productId: json["productId"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
  };
}
