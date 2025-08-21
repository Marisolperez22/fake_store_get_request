import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';
import 'package:mockito/mockito.dart';

void setupDummies() {
  provideDummy<Product>(
    Product(
      id: 1,
      title: 'Dummy Product',
      price: 0.0,
      description: 'Dummy description',
      category: 'dummy',
      image: 'dummy.jpg',
      rating: RatingEntity(rate: 0.0, count: 0),
    ),
  );

  provideDummy<Either<Failure, List<Product>>>(Right([]));
  provideDummy<Either<Failure, String>>(Right(''));
  provideDummy<Either<Failure, List<String>>>(Right([]));
  provideDummy<Either<Failure, LoginResponse>>(Right(LoginResponse(token: '')));
  provideDummy<Either<Failure, Cart>>(Right(Cart(
    id: 0,
    userId: 0,
    date: '',
    products: [],
  )));

  provideDummy<ServerFailure>(ServerFailure(500));
  provideDummy<NetworkFailure>(NetworkFailure());
  provideDummy<TimeOutFailure>(TimeOutFailure());
  provideDummy<AnotherFailure>(AnotherFailure());
  provideDummy<DataNull>(DataNull());
}

