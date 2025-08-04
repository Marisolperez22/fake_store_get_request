import 'rating.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/entities/rating_entity.dart';

class Product {
  final int id;
  final String? title;
  final double? price;
  final String? image;
  final String? category;
  final String? description;
  final RatingEntity? rating;

  Product({
    this.title,
    this.price,
    this.image,
    this.rating,
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

extension ProductMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      image: image,
      category: category,
      description: description,
      rating:
          rating != null
              ? RatingEntity(rate: rating!.rate, count: rating!.count)
              : null,
    );
  }
}

extension ProductListMapper on List<Product> {
  List<ProductEntity> toEntityList() {
    return map((product) => product.toEntity()).toList();
  }
}
