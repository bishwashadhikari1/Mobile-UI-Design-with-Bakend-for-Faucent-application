// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletHiveModelAdapter extends TypeAdapter<WalletHiveModel> {
  @override
  final int typeId = 1;

  @override
  WalletHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletHiveModel(
      walletId: fields[0] as String,
      lastActive: fields[1] as DateTime,
      balance: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalletHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.walletId)
      ..writeByte(1)
      ..write(obj.lastActive)
      ..writeByte(2)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
