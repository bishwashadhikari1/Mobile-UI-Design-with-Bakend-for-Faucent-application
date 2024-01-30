import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/auth_remote_repo.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return ref.read(authRemoteRepositoyProvider);
});

abstract class IAuthRepository {
  Future<Either<Failure, String>> uploadDocument(File image);
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
  });
  Future<Either<Failure, UserEntity>> loginStudent({
    required String email,
    required String password,
  });
  Future<Either<Failure, bool>> checkDeviceSupportForBiometrics();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, bool>> deleteUserProfile({
    required String userID,
  });
  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity user,
  }) ;
}
