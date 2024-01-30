import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talab/core/failure/failure.dart';

final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
  return UserSharedPrefs();
});

class UserSharedPrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setUserToken(String token) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token', token);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setUserTokenTwo(String token) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token2', token);
      await _sharedPreferences.setString('token', token);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  //Get user token
  Future<Either<Failure, String>> getUserToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String? token = _sharedPreferences.getString('token');
      if (token != null) {
        return Right(token);
      } else {
        return Left(Failure(error: 'No token found'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, String>> getUserTokenTwo() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String? token = _sharedPreferences.getString('token2');
      if (token != null) {
        return Right(token);
      } else {
        return Left(Failure(error: 'No token found'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setBiometrics(bool token) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setBool('allowBiometric', token);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> getBiometrics() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      bool? token = _sharedPreferences.getBool('allowBiometric');
      if (token != null) {
        return Right(token);
      } else {
        return Left(Failure(error: 'No biometrics found'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
