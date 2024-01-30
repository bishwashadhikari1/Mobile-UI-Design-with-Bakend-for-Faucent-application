import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talab/config/constants/hive_table_constant.dart';
import 'package:talab/features/wallet/data/model/wallet_hive_model.dart';

import '../../../features/contract/data/model/contract_hive_model.dart';

//Provider
final hiveServiceProvider = Provider((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(WalletHiveModelAdapter());
    Hive.registerAdapter(ContractHiveModelAdapter());
    log('Hive Init Ran');
  }

  // ------------Wallet  QUERIES ---------------

  Future<void> addWallet(WalletHiveModel wallet) async {
    var box = await Hive.openBox<WalletHiveModel>(HiveTableConstant.walletBox);
    await box.put(wallet.walletId, wallet);
    box.close();
  }

  Future<WalletHiveModel> getWalletById(String walletId) async {
    var box = await Hive.openBox<WalletHiveModel>(HiveTableConstant.walletBox);
    print('nualasl: ${box.keys}');

    var wallet = await box.get(walletId);
    box.close();

    return wallet!;
  }
  // ------------Contract  QUERIES ---------------

  Future<void> addContract(ContractHiveModel contract) async {
    var box =
        await Hive.openBox<ContractHiveModel>(HiveTableConstant.contractBox);
    await box.put(contract.contractId, contract);
    box.close();
  }

  Future<ContractHiveModel?> getContractById(String contractId) async {
    var box =
        await Hive.openBox<ContractHiveModel>(HiveTableConstant.contractBox);
    var contract = await box.get(contractId);
    box.close();

    return contract;
  }

  // update contract delete contract , end contract
  Future<void> updateContract(ContractHiveModel contract) async {
    var box =
        await Hive.openBox<ContractHiveModel>(HiveTableConstant.contractBox);
    await box.put(contract.contractId, contract);
    box.close();
  }

  Future<void> deleteContract(String contractId) async {
    var box =
        await Hive.openBox<ContractHiveModel>(HiveTableConstant.contractBox);
    await box.delete(contractId);
    box.close();
  }

  Future<void> endContract(String contractId) async {
    var box =
        await Hive.openBox<ContractHiveModel>(HiveTableConstant.contractBox);
    var contract = await box.get(contractId);
    contract!.status = "Expired";
    await box.put(contractId, contract);
    box.close();
  }
}
