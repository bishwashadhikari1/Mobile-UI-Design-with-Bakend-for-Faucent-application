import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

import '../../../../core/failure/failure.dart';
import '../repository/auth_repository.dart';

final authUseCaseProvider = Provider((ref) {
  return AuthUseCase(
    ref.read(authRepositoryProvider),
  );
});

class AuthUseCase {
  final IAuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<Either<Failure, String>> uploadProfileProfile(File file) async {
    return await _authRepository.uploadDocument(file);
  }

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
    return _authRepository.registerStudent(
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
      photo: photo,
      accountType: accountType,
      walletId: walletId,
    );
  }

  Future<Either<Failure, UserEntity>> loginStudent(
      String username, String password) async {
    return await _authRepository.loginStudent(
        email: username, password: password);
  }
  Future<Either<Failure, bool>> checkDeviceSupportForBiometrics() async {
    return await _authRepository.checkDeviceSupportForBiometrics();
  }
  //logout
  Future<Either<Failure, bool>> logout() async {
    return await _authRepository.logout();
  }
   Future<Either<Failure, bool>> deleteUserProfile({
    required String userID,
  }) async {
    return await _authRepository.deleteUserProfile(
      userID: userID,

    );
  }
  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity user,
  }) async {
    return await _authRepository.updateUser(
      user: user,
    );
  }
}
