import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/core/network/local/hive_service.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';
import 'package:talab/features/contract/data/model/contract_hive_model.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';

final contractLocalDataSourceProvider = Provider<ContractLocalDataSource>(
    (ref) {
  return ContractLocalDataSource(
      hiveService: ref.read(hiveServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});

class ContractLocalDataSource {
  final UserSharedPrefs userSharedPrefs;
  final HiveService hiveService;

  ContractLocalDataSource({
    required this.userSharedPrefs,
    required this.hiveService,
  });

  Future<Either<Failure, ContractEntity>> getContractById(
      String contractID) async {
    try {
      var contract = await hiveService.getContractById(contractID);
      return Right(contract!.toEntity());
    } catch (e) {
      return Left(Failure(error: e.toString(), statuscode: '0'));
    }
  }

  // Future<Either<Failure, List<ContractEntity>>> getAllContracts() async {
  //   try {
  //     var contracts = await hiveService.get();
  //     return Right(contracts.map((e) => e.toEntity()).toList());
  //   } catch (e) {
  //     return Left(Failure(error: e.toString(), statuscode: '0'));
  //   }
  // }

  Future<Either<Failure, List<ContractEntity>>> getContractsById(
      String role) async {
    try {
      var contracts = await hiveService.getContractById(role);
      return Right(contracts?.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(Failure(error: e.toString(), statuscode: '0'));
    }
  }



}
