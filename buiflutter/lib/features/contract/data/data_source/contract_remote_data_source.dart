import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/network/remote/http_service.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entity/contract_entity.dart';

final contractsRemoteDataSourceProvider =
    Provider<ContractsRemoteDataSource>((ref) {
  return ContractsRemoteDataSource(
      api: ref.read(httpServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});

class ContractsRemoteDataSource {
  final HttpService api;
  final UserSharedPrefs userSharedPrefs;

  //get all contracts
  Future<Either<Failure, List<ContractEntity>>> getAllContracts() async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      Response response = await api.httpService.get(
        ApiEndpoints.getAllContracts,
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );

      List<dynamic> responseData = response.data;
      List<ContractEntity> contracts = responseData
          .map((contractData) => ContractEntity.fromMap(contractData))
          .toList();

      return Right(contracts);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  // constructor
  ContractsRemoteDataSource({required this.api, required this.userSharedPrefs});

  // get contracts by role and id
  Future<Either<Failure, List<ContractEntity>>> filterContractsByRoleAndId(
      {required String role, required String walletId}) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      Response response = await await api.httpService.post(
        ApiEndpoints.getContractById,
        data: {
          'role': role,
          'id': walletId,
        },
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );

      List<dynamic> responseData = response.data;
      List<ContractEntity> contracts = responseData
          .map((contractData) => ContractEntity.fromMap(contractData))
          .toList();

      return Right(contracts);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  // create new contract
  Future<Either<Failure, ContractEntity>> createContract({
    required String employerWalletID,
    required String employeeWalletID,
    required int collateral,
    required int duration,
    required String startFrom,
    required int totalAmount,
    required String role,
  }) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      Response response = await api.httpService.post(
        ApiEndpoints.createContract,
        data: {
          'employer_wallet': employerWalletID,
          'employee_wallet': employeeWalletID,
          'collateral': collateral,
          'duration': duration,
          'start_from': startFrom,
          'total_amount': totalAmount,
          'role': role,
        },
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );

      ContractEntity createdContract = ContractEntity.fromMap(response.data);

      return Right(createdContract);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  //update contract
  Future<Either<Failure, ContractEntity>> updateContract(
      {required String contractID, required ContractEntity contract}) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      Response response = await api.httpService.put(
        ApiEndpoints.updateContract + '/$contractID',
        data: {
          'employer_wallet': contract.employerWalletId,
          'employee_wallet': contract.employeeWalletId,
          'collateral': contract.collateral,
          'duration': contract.duration,
          'start_from': contract.startFrom,
          'total_amount': contract.totalAmount,
          'role': 'employer',
          'status': contract.status,
        },
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );
      ContractEntity updatedContract = ContractEntity.fromMap(response.data);

      return Right(updatedContract);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  //end contract
  Future<Either<Failure, ContractEntity>> endContract(
      String id, ContractEntity contract) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      Response response = await api.httpService.patch(
        ApiEndpoints.updateContract + '/$id/end',
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );
      ContractEntity updatedContract = ContractEntity.fromMap(response.data);

      return Right(updatedContract);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

  Future<Either<Failure, bool>> deleteContract({
    required String contractId,
  }) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);

      await api.httpService.delete(
        '${ApiEndpoints.deleteContract}$contractId',
        options: Options(headers: {"Authorization": "Bearer ${token}"}),
      );

      return Right(true);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.response?.data['error'],
        statuscode: e.response?.statusCode.toString() ?? '0',
      ));
    }
  }

// get all employees
  Future<Either<Failure, List<UserEntity>>> getAllEmployees() async {
    try {
      Response response = await api.httpService.post(
        ApiEndpoints.getAllEmployees,
      );
      List<UserEntity> data = [];
      response.data.forEach((employee) {
        data.add(UserEntity.fromApiMap(employee));
      });

      return Right(data);
    } on DioError catch (e) {
      return Left(Failure(
        error: e.message,
        statuscode: '0',
      ));
    }
  }
}
