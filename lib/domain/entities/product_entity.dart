import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String? title;
  final double? price;
  final String? image;
  final String? category;
  final String? description;
  final RatingEntity? rating;

  const ProductEntity({
    this.title,
    this.price,
    this.image,
    this.rating,
    this.category,
    this.description,
    required this.id,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    image,
    category,
    description,
    rating,
  ];

  @override
  String toString() {
    return 'ProductEntity{'
        'id: $id, '
        'title: $title, '
        'price: $price, '
        'category: $category, '
        'description: ${description?.substring(0, min(20, description?.length ?? 0))}..., '
        'image: $image, '
        'rating: $rating'
        '}';
  }
}
