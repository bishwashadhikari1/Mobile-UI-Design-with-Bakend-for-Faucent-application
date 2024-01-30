import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

import '../../domain/repository/auth_repository.dart';

final authRemoteRepositoyProvider = Provider<IAuthRepository>((ref) {
  return AuthRemoteRepositiry(
    authRemoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

class AuthRemoteRepositiry implements IAuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRemoteRepositiry({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, String>> uploadDocument(File image) async {
    return await authRemoteDataSource.uploadDocument(image);
  }

  @override
  Future<Either<Failure, UserEntity>> loginStudent(
      {required String email, required String password}) async {
    return await authRemoteDataSource.loginStudent(
        username: email, password: password);
  }

  @override
  Future<Either<Failure, bool>> registerStudent({
    required String username,
    required String fullname,
    required String password,
    required String gender,
    required DateTime dob,
    required String address,
    required String email,
    required String phone,
    required String image,
    required String documentImage,
    required String documentIdNumber,
    String? photo,
    required String accountType,
    required String walletId,
  }) {
    return authRemoteDataSource.registerUser(
      username: username,
      fullname: fullname,
      password: password,
      gender: gender,
      dob: dob,
      address: address,
      email: email,
      phone: phone,
      image: image,
      documentImage: documentImage,
      documentIdNumber: documentIdNumber,
      accountType: accountType,
      walletId: walletId,
    );
  }

  Future<Either<Failure, bool>> checkDeviceSupportForBiometrics() async {
    return await authRemoteDataSource.checkDeviceSupportForBiometrics();
  }

  //logout
  Future<Either<Failure, bool>> logout() async {
    return await authRemoteDataSource.logout();
  }

  @override
  Future<Either<Failure, bool>> deleteUserProfile(
      {required String userID}) async {
    log('remote repo hit');

    return await authRemoteDataSource.deleteUserProfile(userID: userID);
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity user,
  }) async {
    return await authRemoteDataSource.updateUser(
      user: user,
    );
  }
}
