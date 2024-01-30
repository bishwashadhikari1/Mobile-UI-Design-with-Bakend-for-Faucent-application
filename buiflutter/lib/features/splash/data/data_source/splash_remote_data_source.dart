import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/constants/api_endpoint.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/core/network/remote/http_service.dart';
import 'dart:developer';

final splashRemoteDataSourceProvider = Provider<SplashRemoteDataSource>((ref) {
  return SplashRemoteDataSource(
    api: ref.read(httpServiceProvider),
  );
});

class SplashRemoteDataSource {
  final HttpService api;

  const SplashRemoteDataSource({required this.api});

  Future<Either<Failure, Map<String, dynamic>>> initialLogin(
      {required String token, biometrics = false}) async {
    try {
      final response = await api.httpService.post(
        ApiEndpoints.loginWithToken,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data['user'];
        return Right(userData);
      } else {
        return Left(
          Failure(
            error: response.data['error'],
          ),
        );
      }
    } catch (e) {
      return Left(
        Failure(
          error: 'Session timed out.',
        ),
      );
    }
  }
}
