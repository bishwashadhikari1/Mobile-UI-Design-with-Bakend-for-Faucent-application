import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/contract/data/repository/contract_remote_repo.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';
import 'package:talab/features/contract/domain/repository/contract_repository.dart';

final contractUseCaseProvider = Provider<ContractUseCase>((ref) {
  return ContractUseCase(contractRepo: ref.read(contractRemoteRepoProvider));
});

class ContractUseCase {
  final IContractRepo contractRepo;

  ContractUseCase({required this.contractRepo});

  Future<Either<Failure, List<ContractEntity>>> filterContractsByRoleAndId(
      {required String role, required String walletId}) async {
    return await contractRepo.filterContractsByRoleAndId(
        role: role, walletId: walletId);
  }

  Future<Either<Failure, ContractEntity>> createContract({
    required String employerWalletID,
    required String employeeWalletID,
    required int collateral,
    required DateTime startFrom,
    required DateTime endFrom,
    required int totalAmount,
    required String role,
  }) async {
    final int duration = endFrom.difference(startFrom).inMinutes;

    return await contractRepo.createContract(
      employerWalletID: employerWalletID,
      employeeWalletID: employeeWalletID,
      collateral: collateral,
      duration: duration,
      startFrom: startFrom.toLocal().toString(),
      totalAmount: totalAmount,
      role: role,
    );
  }

  Future<Either<Failure, List<UserEntity>>> getAllEmployees() async {
    return await contractRepo.getAllEmployees();
  }

  Future<Either<Failure, ContractEntity>> updateContract(
      {required String contractID, required ContractEntity contract}) async {
    return await contractRepo.updateContract(
      contractID: contractID,
      contract: contract,
    );
  }

  Future<Either<Failure, bool>> deleteContract({
    required String contractId,
  }) async {
    return await contractRepo.deleteContract(contractId: contractId);
  }
}
