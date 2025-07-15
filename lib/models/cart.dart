class Cart {
  final int productId;
  final int quantity;

  Cart({required this.productId, required this.quantity});

  factory Cart.fromJson(Map<String, dynamic> json) =>
      Cart(productId: json["productId"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
  };
}
