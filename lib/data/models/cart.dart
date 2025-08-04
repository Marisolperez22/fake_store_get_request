import '../../domain/entities/cart_entity.dart';

class Cart extends CartEntity {
  Cart({required super.productId, required super.quantity});

  factory Cart.fromJson(Map<String, dynamic> json) =>
      Cart(productId: json["productId"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
  };
}
