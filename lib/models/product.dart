class Product {
  final int id;
  final String? title;
  final double? price;
  final String? image;
  final Rating? rating;
  final String? category;
  final String? description;

  Product({
    this.rating,
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
      rating: Rating.fromJson(json['rating']),
    );
  }
}

class Rating {
  final double? rate;
  final double? count;

  Rating({this.rate, this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: json['rate'], count: json['count']);
  }
}
