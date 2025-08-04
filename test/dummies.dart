import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';
import 'package:mockito/mockito.dart';

void setupDummies() {
  provideDummy<ProductEntity>(
    ProductEntity(
      id: 1,
      title: 'Dummy Product',
      price: 0.0,
      description: 'Dummy description',
      category: 'dummy',
      image: 'dummy.jpg',
      rating: RatingEntity(rate: 0.0, count: 0),
    ),
  );

  provideDummy<Either<Failure, List<ProductEntity>>>(Right([]));

  provideDummy<ServerFailure>(ServerFailure(500));
  provideDummy<NetworkFailure>(NetworkFailure());
  provideDummy<TimeOutFailure>(TimeOutFailure());
  provideDummy<AnotherFailure>(AnotherFailure());
  provideDummy<DataNull>(DataNull());
}
