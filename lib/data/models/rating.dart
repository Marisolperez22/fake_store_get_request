import '../../domain/entities/rating_entity.dart';

class Rating extends RatingEntity {
  Rating({required super.count, required super.rate});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: json['rate'], count: json['count']);
  }
}
