import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:talab/core/network/remote/http_service.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/auth/presentation/viewmodel/auth_viewmodel.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
      api: ref.read(httpServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});

class AuthRemoteDataSource {
  final HttpService api;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.api, required this.userSharedPrefs});
  Future<Either<Failure, bool>> registerUser({
    required String username,
    required String fullname,
    required String password,
    required String gender,
    required DateTime dob,
    required String address,
    required String email,
    required String phone,
    String? image,
    required String documentImage,
    required String documentIdNumber,
    required String accountType,
    required String walletId,
  }) async {
    try {
      Response response = await api.httpService.post(
        ApiEndpoints.register,
        data: {
          'username': username,
          'fullname': fullname,
          'password': password,
          'gender': gender,
          'dob': dob.toIso8601String(),
          'address': address,
          'email': email,
          'phone': phone,
          'image': image ?? '',
          'document_image': documentImage,
          'document_id_number': documentIdNumber,
          'account_type': accountType,
          'wallet_id': walletId,
        },
      );
      return Right(true);
    } on DioError catch (e) {
      print(
          'Error info: ${e.response?.data['error']}'); //print the server's response if any
      return Left(
        Failure(
          error: e.response?.data['error'],
        ),
      );
    } catch (e) {
      // This will catch any other exceptions
      print('Unknown error: $e');
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, UserEntity>> loginStudent({
    required String username,
    required String password,
  }) async {
    try {
      Response response = await api.httpService.post(ApiEndpoints.login, data: {
        'email': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        String token = response.data["token"];
        await userSharedPrefs.setUserToken(token);
        await userSharedPrefs.setUserTokenTwo(token);
        final apiUser = response.data['user'];
        apiUser['token'] = token;
        final user = UserEntity.fromApiMap(apiUser);

        return Right(user);
      } else {
        return left(
          Failure(
            error: response.data["message"],
            statuscode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.response?.data['error'],
          statuscode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> uploadDocument(
    File image,
  ) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formdata = FormData.fromMap({
        'document':
            await MultipartFile.fromFile(image.path, filename: fileName),
      });

      print('here ${image.path} ${fileName}');
      Response response =
          await api.httpService.post(ApiEndpoints.uploadDocs, data: formdata);
      print('resp  $response');

      return Right(response.data['data']);
    } on DioError catch (e) {
      print('Dio error message: ${e.message}');
      print('Dio error response: ${e.response?.data}');
      return Left(Failure(
          error: e.error.toString(),
          statuscode: e.response?.statusCode.toString() ?? "0"));
    }
  }

  Future<Either<Failure, bool>> checkDeviceSupportForBiometrics() async {
    try {
      return Right(await LocalAuthentication().isDeviceSupported());
    } catch (e) {
      return Left(
        Failure(
          error: e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> logout() async {
    try {
      await userSharedPrefs.setUserToken("");
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  // data source for update user profile
  Future<Either<Failure, UserEntity>> updateUser({
required UserEntity user,
  }) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);
      Response response = await api.httpService.put(
        ApiEndpoints.updateUser + '${user.id}',
        data: {
          'fullname': user.fullname,
          'address': user.address,
          'phone': user.phone,
        },
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );
      if (response.statusCode == 200) {
        final apiUser = response.data['user'];
        final user = UserEntity.fromApiMap(apiUser);

        return Right(user);
      } else {
        return left(
          Failure(
            error: response.data["message"],
            statuscode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      print(
          'Error info: ${e.response?.data['error']}'); //print the server's response if any
      return Left(
        Failure(
          error: e.response?.data['error'],
        ),
      );
    } catch (e) {
      // This will catch any other exceptions
      print('Unknown error: $e');
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserProfile(
      {required String userID}) async {
    log('data source hit');
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);
      log(token.runtimeType.toString());
      final response = await api.httpService.delete(
        ApiEndpoints.deleteUser,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return const Right(true);
    } catch (e) {
      return Left(
        Failure(
          error: e.toString(),
        ),
      );
    }
  }
}
