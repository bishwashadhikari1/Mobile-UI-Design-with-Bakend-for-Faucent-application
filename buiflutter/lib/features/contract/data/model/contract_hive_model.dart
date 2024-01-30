import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart'; // Import the ContractEntity here
import '../../../../config/constants/hive_table_constant.dart';
part 'contract_hive_model.g.dart';
// dart run build_runner build --delete-conflicting-outputs

final contractHiveModelProvider = Provider(
  (ref) => ContractHiveModel.empty(),
);

@HiveType(
    typeId: HiveTableConstant
        .contractTableId) // Make sure you have a unique typeId for contracts
class ContractHiveModel {
  @HiveField(0)
  final String contractId;

  @HiveField(1)
  final String employerWalletId;

  @HiveField(2)
  final String employeeWalletId;

  @HiveField(3)
  final String employerUsername;

  @HiveField(4)
  final String employeeUsername;

  @HiveField(5)
  final String createdAt;

  @HiveField(6)
  final String startFrom;

  @HiveField(7)
  final bool employerSigned;

  @HiveField(8)
  final bool employeeSigned;

  @HiveField(9)
  final int duration;

  @HiveField(10)
  final double totalAmount;

  @HiveField(11)
  late final bool isActive;

  @HiveField(12)
  final bool hasEnded;

  @HiveField(13)
  final double paidUpAmount;

  @HiveField(14)
  final double transactionAmountPerTransfer;

  @HiveField(15)
  final double collateral;

  @HiveField(16)
  final bool renew;

  @HiveField(17)
   late final String status;

  @HiveField(18)
  final bool reminder20;

  @HiveField(19)
  final bool reminder10;

  @HiveField(20)
  final bool reminder5;

  // Constructor
  ContractHiveModel({
    required this.contractId,
    required this.employerWalletId,
    required this.employeeWalletId,
    required this.employerUsername,
    required this.employeeUsername,
    required this.createdAt,
    required this.startFrom,
    required this.employerSigned,
    required this.employeeSigned,
    required this.duration,
    required this.totalAmount,
    required this.isActive,
    required this.hasEnded,
    required this.paidUpAmount,
    required this.transactionAmountPerTransfer,
    required this.collateral,
    required this.renew,
    required this.status,
    required this.reminder20,
    required this.reminder10,
    required this.reminder5,
  });

  // empty constructor
  ContractHiveModel.empty()
      : this(
          contractId: '',
          employerWalletId: '',
          employeeWalletId: '',
          employerUsername: '',
          employeeUsername: '',
          createdAt: '',
          startFrom: '',
          employerSigned: false,
          employeeSigned: false,
          duration: 0,
          totalAmount: 0.0,
          isActive: false,
          hasEnded: false,
          paidUpAmount: 0.0,
          transactionAmountPerTransfer: 0.0,
          collateral: 0.0,
          renew: false,
          status: 'active',
          reminder20: false,
          reminder10: false,
          reminder5: false,
        );

// Convert Hive Object to Entity
  ContractEntity toEntity() => ContractEntity(
        contractId: contractId,
        employerWalletId: employerWalletId,
        employeeWalletId: employeeWalletId,
        employerUsername: employerUsername,
        employeeUsername: employeeUsername,
        createdAt: createdAt,
        startFrom: startFrom,
        employerSigned: employerSigned,
        employeeSigned: employeeSigned,
        duration: duration,
        totalAmount: totalAmount,
        isActive: isActive,
        hasEnded: hasEnded,
        paidUpAmount: paidUpAmount,
        transactionAmountPerTransfer: transactionAmountPerTransfer,
        collateral: collateral,
        renew: renew,
        status: status,
        reminder20: reminder20,
        reminder10: reminder10,
        reminder5: reminder5,
      );

// Convert Entity to Hive Object
  ContractHiveModel toHiveModel(ContractEntity entity) => ContractHiveModel(
        contractId: entity.contractId,
        employerWalletId: entity.employerWalletId,
        employeeWalletId: entity.employeeWalletId,
        employerUsername: entity.employerUsername,
        employeeUsername: entity.employeeUsername,
        createdAt: entity.createdAt,
        startFrom: entity.startFrom,
        employerSigned: entity.employerSigned,
        employeeSigned: entity.employeeSigned,
        duration: entity.duration,
        totalAmount: entity.totalAmount,
        isActive: entity.isActive,
        hasEnded: entity.hasEnded,
        paidUpAmount: entity.paidUpAmount,
        transactionAmountPerTransfer: entity.transactionAmountPerTransfer,
        collateral: entity.collateral,
        renew: entity.renew,
        status: entity.status,
        reminder20: entity.reminder20,
        reminder10: entity.reminder10,
        reminder5: entity.reminder5,
      );

// Convert Entity List to Hive List
  List<ContractHiveModel> toHiveModelList(List<ContractEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  @override
  String toString() {
    return 'ContractId: $contractId, EmployerWalletId: $employerWalletId, EmployeeWalletId: $employeeWalletId, EmployerUsername: $employerUsername, EmployeeUsername: $employeeUsername, CreatedAt: $createdAt, StartFrom: $startFrom, TotalAmount: $totalAmount, Status: $status';
  }

  map(Function(dynamic e) param0) {}
}
