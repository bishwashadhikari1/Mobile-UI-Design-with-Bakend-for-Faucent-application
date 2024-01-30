import 'package:dartz/dartz.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

abstract class ISplashRepository {
  Future<Either<Failure, UserEntity>> loginWithToken({
    required String token,
  });
}
