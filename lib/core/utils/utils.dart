import 'package:either_dart/either.dart';

import '../errors/failures.dart';

class Utils {
  static Either<Failure, T> handleException<T>(dynamic e) {
    if (e.type == 'TimeoutException') {
      return const Left(TimeOutFailure());
    }
    if (e.type == 'UnAuthorization') {
      return const Left(AuthFailure());
    }
    if (e.type == 'BadRequest') {
      return Left(
        BadRequest(title: e.title, message: e.message, codeError: e.codeError),
      );
    }
    return const Left(AnotherFailure());
  }
}
