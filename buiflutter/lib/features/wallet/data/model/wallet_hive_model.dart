import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:talab/features/wallet/domain/entity/wallet_entity.dart';
import '../../../../config/constants/hive_table_constant.dart';
part 'wallet_hive_model.g.dart';
// dart run build_runner build --delete-conflicting-outputs

final walletHiveModelProvider = Provider(
  (ref) => WalletHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.walletTableId)
class WalletHiveModel {
  @HiveField(0)
  final String walletId;

  @HiveField(1)
  final DateTime lastActive;

  @HiveField(2)
  final double balance;

  // Constructor
  WalletHiveModel({
    required this.walletId,
    required this.lastActive,
    required this.balance,
  });

  // empty constructor
  WalletHiveModel.empty()
      : this(
          walletId: '',
          lastActive: DateTime.now(),
          balance: 0.0,
  );

  // Convert Hive Object to Entity
  WalletEntity toEntity() => WalletEntity(
        walletId: walletId,
        lastActive: lastActive,
        balance: balance,
  );

  // Convert Entity to Hive Object
  WalletHiveModel toHiveModel(WalletEntity entity) => WalletHiveModel(
        walletId: entity.walletId,
        lastActive: entity.lastActive,
        balance: entity.balance,
      );

  // Convert Entity List to Hive List
  List<WalletHiveModel> toHiveModelList(List<WalletEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  @override
  String toString() {
    return 'WalletId: $walletId, LastActive: $lastActive, Balance: $balance ';
  }
}
