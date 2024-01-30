import 'package:dartz/dartz.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';

abstract class IContractRepo {
  Future<Either<Failure, List<ContractEntity>>> filterContractsByRoleAndId(
      {required String role, required String walletId});
  Future<Either<Failure, ContractEntity>> createContract({
    required String employerWalletID,
    required String employeeWalletID,
    required int collateral,
    required int duration,
    required String startFrom,
    required int totalAmount,
    required String role,
  });
  Future<Either<Failure, List<UserEntity>>> getAllEmployees();
  Future<Either<Failure, ContractEntity>> updateContract(
      {required String contractID, required ContractEntity contract});
  Future<Either<Failure, bool>> deleteContract({
    required String contractId,
  });
}
