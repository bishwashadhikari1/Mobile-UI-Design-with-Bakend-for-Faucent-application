import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/splash/data/data_source/splash_remote_data_source.dart';
import 'package:talab/features/splash/domain/repository/splash_repository.dart';

final splashRepositoryProvider = Provider<ISplashRepository>((ref) {
  return SplashRepositoryImpl(
    splashRemoteDataSource: ref.read(splashRemoteDataSourceProvider),
  );
});

class SplashRepositoryImpl extends ISplashRepository {
  final SplashRemoteDataSource splashRemoteDataSource;

  SplashRepositoryImpl({
    required this.splashRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithToken({
    required String token,biometrics = false
  }) async {
    try {
      final response = await splashRemoteDataSource.initialLogin(token: token);
      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          return Right(UserEntity.fromApiMap(r));
        },
      );
    } catch (e) {
      return Left(
        Failure(
          error: e.toString(),
          
        ),
      );
    }
  }
}
