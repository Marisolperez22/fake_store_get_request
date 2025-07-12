class Product {
  final int id;
  final String? title;
  final double? price;
  final String? image;
  final String? category;
  final String? description;

  Product({
    this.title,
    this.price,
    this.image,
    this.category,
    this.description,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      category: json['category'],
      description: json['description'],
      price: (json['price']).toDouble(),
    );
  }
}
