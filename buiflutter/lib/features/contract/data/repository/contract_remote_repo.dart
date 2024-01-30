import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/contract/data/data_source/contract_remote_data_source.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';
import 'package:talab/features/contract/domain/repository/contract_repository.dart';

final contractRemoteRepoProvider = Provider<IContractRepo>((ref) {
  return ContractRemoteRepoImpl(
      contractsRemoteDataSource: ref.read(contractsRemoteDataSourceProvider));
});

class ContractRemoteRepoImpl extends IContractRepo {
  final ContractsRemoteDataSource contractsRemoteDataSource;

  ContractRemoteRepoImpl({required this.contractsRemoteDataSource});

  @override
  Future<Either<Failure, List<ContractEntity>>> filterContractsByRoleAndId(
      {required String role, required String walletId}) async {
    return await contractsRemoteDataSource.filterContractsByRoleAndId(
        role: role, walletId: walletId);
  }

  @override
  Future<Either<Failure, ContractEntity>> createContract({
    required String employerWalletID,
    required String employeeWalletID,
    required int collateral,
    required int duration,
    required String startFrom,
    required int totalAmount,
    required String role,
  }) async {
    return await contractsRemoteDataSource.createContract(
      employerWalletID: employerWalletID,
      employeeWalletID: employeeWalletID,
      collateral: collateral,
      duration: duration,
      startFrom: startFrom,
      totalAmount: totalAmount,
      role: role,
    );
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllEmployees() async {
    return await contractsRemoteDataSource.getAllEmployees();
  }

  @override
  Future<Either<Failure, ContractEntity>> updateContract(
      {required String contractID, required ContractEntity contract}) async {
    return await contractsRemoteDataSource.updateContract(
      contractID: contractID,
      contract: contract,
    );
  }

  @override
  Future<Either<Failure, bool>> deleteContract({
    required String contractId,
  }) async {
    return await contractsRemoteDataSource.deleteContract(
      contractId: contractId,
    );
  }
}
