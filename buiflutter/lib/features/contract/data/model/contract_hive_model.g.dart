// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractHiveModelAdapter extends TypeAdapter<ContractHiveModel> {
  @override
  final int typeId = 3;

  @override
  ContractHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractHiveModel(
      contractId: fields[0] as String,
      employerWalletId: fields[1] as String,
      employeeWalletId: fields[2] as String,
      employerUsername: fields[3] as String,
      employeeUsername: fields[4] as String,
      createdAt: fields[5] as String,
      startFrom: fields[6] as String,
      employerSigned: fields[7] as bool,
      employeeSigned: fields[8] as bool,
      duration: fields[9] as int,
      totalAmount: fields[10] as double,
      isActive: fields[11] as bool,
      hasEnded: fields[12] as bool,
      paidUpAmount: fields[13] as double,
      transactionAmountPerTransfer: fields[14] as double,
      collateral: fields[15] as double,
      renew: fields[16] as bool,
      status: fields[17] as String,
      reminder20: fields[18] as bool,
      reminder10: fields[19] as bool,
      reminder5: fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ContractHiveModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.contractId)
      ..writeByte(1)
      ..write(obj.employerWalletId)
      ..writeByte(2)
      ..write(obj.employeeWalletId)
      ..writeByte(3)
      ..write(obj.employerUsername)
      ..writeByte(4)
      ..write(obj.employeeUsername)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.startFrom)
      ..writeByte(7)
      ..write(obj.employerSigned)
      ..writeByte(8)
      ..write(obj.employeeSigned)
      ..writeByte(9)
      ..write(obj.duration)
      ..writeByte(10)
      ..write(obj.totalAmount)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.hasEnded)
      ..writeByte(13)
      ..write(obj.paidUpAmount)
      ..writeByte(14)
      ..write(obj.transactionAmountPerTransfer)
      ..writeByte(15)
      ..write(obj.collateral)
      ..writeByte(16)
      ..write(obj.renew)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.reminder20)
      ..writeByte(19)
      ..write(obj.reminder10)
      ..writeByte(20)
      ..write(obj.reminder5);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
