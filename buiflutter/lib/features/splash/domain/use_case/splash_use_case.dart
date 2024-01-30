import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/splash/domain/repository/splash_repository.dart';

import '../../../../core/shared_prefs/user_sharedprefs.dart';
import '../../data/repository/splash_repository.dart';

final splashUseCaseProvider = Provider<SplashUseCase>((ref) {
  return SplashUseCase(
    splashRepository: ref.read(splashRepositoryProvider),
    sharedPref: ref.read(userSharedPrefsProvider),
  );
});

class SplashUseCase {
  final ISplashRepository splashRepository;
  final UserSharedPrefs sharedPref;

  const SplashUseCase({
    required this.splashRepository,
    required this.sharedPref,
  });

  Future<Either<Failure, UserEntity>> loginWithToken({biometics = false}) async {
 

    try {
      var tokenEither = await sharedPref.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);
      var tokenEitherTwo = await sharedPref.getUserTokenTwo();
      String tokenTwo = tokenEitherTwo.fold((l) => '', (r) => r);

      final response = await splashRepository.loginWithToken(
        token: biometics ? tokenTwo : token,
      );

      log('response from splash usecase $response');
             
      return response;
    } catch (e) {
      log('eta pugyo' + e.toString());
      rethrow;
    }
  }
}
