// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContractEntity {
  final String contractId; // You might want a unique identifier for contracts
  final String employerWalletId;
  final String employeeWalletId;
  final String employerUsername;
  final String employeeUsername;
  final String createdAt;
  final String startFrom;
  final bool employerSigned;
  final bool employeeSigned;
  final int duration;
  final double totalAmount;
  final bool isActive;
  final bool hasEnded;
  final double paidUpAmount;
  final double transactionAmountPerTransfer;
  final double collateral;
  final bool renew;
  final String status; // You might want to consider using an enum here
  final bool reminder20;
  final bool reminder10;
  final bool reminder5;
  ContractEntity({
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

  ContractEntity copyWith({
    String? contractId,
    String? employerWalletId,
    String? employeeWalletId,
    String? employerUsername,
    String? employeeUsername,
    String? createdAt,
    String? startFrom,
    bool? employerSigned,
    bool? employeeSigned,
    int? duration,
    double? totalAmount,
    bool? isActive,
    bool? hasEnded,
    double? paidUpAmount,
    double? transactionAmountPerTransfer,
    double? collateral,
    bool? renew,
    String? status,
    bool? reminder20,
    bool? reminder10,
    bool? reminder5,
  }) {
    return ContractEntity(
      contractId: contractId ?? this.contractId,
      employerWalletId: employerWalletId ?? this.employerWalletId,
      employeeWalletId: employeeWalletId ?? this.employeeWalletId,
      employerUsername: employerUsername ?? this.employerUsername,
      employeeUsername: employeeUsername ?? this.employeeUsername,
      createdAt: createdAt ?? this.createdAt,
      startFrom: startFrom ?? this.startFrom,
      employerSigned: employerSigned ?? this.employerSigned,
      employeeSigned: employeeSigned ?? this.employeeSigned,
      duration: duration ?? this.duration,
      totalAmount: totalAmount ?? this.totalAmount,
      isActive: isActive ?? this.isActive,
      hasEnded: hasEnded ?? this.hasEnded,
      paidUpAmount: paidUpAmount ?? this.paidUpAmount,
      transactionAmountPerTransfer: transactionAmountPerTransfer ?? this.transactionAmountPerTransfer,
      collateral: collateral ?? this.collateral,
      renew: renew ?? this.renew,
      status: status ?? this.status,
      reminder20: reminder20 ?? this.reminder20,
      reminder10: reminder10 ?? this.reminder10,
      reminder5: reminder5 ?? this.reminder5,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contractId': contractId,
      'employerWalletId': employerWalletId,
      'employeeWalletId': employeeWalletId,
      'employerUsername': employerUsername,
      'employeeUsername': employeeUsername,
      'createdAt': createdAt,
      'startFrom': startFrom,
      'employerSigned': employerSigned,
      'employeeSigned': employeeSigned,
      'duration': duration,
      'totalAmount': totalAmount,
      'isActive': isActive,
      'hasEnded': hasEnded,
      'paidUpAmount': paidUpAmount,
      'transactionAmountPerTransfer': transactionAmountPerTransfer,
      'collateral': collateral,
      'renew': renew,
      'status': status,
      'reminder20': reminder20,
      'reminder10': reminder10,
      'reminder5': reminder5,
    };
  }
factory ContractEntity.fromMap(Map<String, dynamic> map) {
  return ContractEntity(
    contractId: map['_id'] as String,
    employerWalletId: map['employer_wallet'] as String,
    employeeWalletId: map['employee_wallet'] as String,
    employerUsername: map['employer_username'] as String,
    employeeUsername: map['employee_username'] as String,
    createdAt: map['created_at'] as String,
    startFrom: map['start_from'] as String,
    employerSigned: map['employer_signed'] as bool,
    employeeSigned: map['employee_signed'] as bool,
    duration: (map['duration'] as num) as int,
    totalAmount: (map['total_amount'] as num).toDouble(),
    isActive: map['is_active'] as bool,
    hasEnded: map['has_ended'] as bool,
    paidUpAmount: (map['paid_up_amount'] as num).toDouble(),
    transactionAmountPerTransfer: (map['transaction_amount_per_transfer'] as num).toDouble(),
    collateral: (map['collateral'] as num).toDouble(),
    renew: map['renew'] as bool,
    status: map['status'] as String,
    reminder20: map['reminder_20'] as bool,
    reminder10: map['reminder_10'] as bool,
    reminder5: map['reminder_5'] as bool,
  );
}


  String toJson() => json.encode(toMap());

  factory ContractEntity.fromJson(String source) => ContractEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContractEntity(contractId: $contractId, employerWalletId: $employerWalletId, employeeWalletId: $employeeWalletId, employerUsername: $employerUsername, employeeUsername: $employeeUsername, createdAt: $createdAt, startFrom: $startFrom, employerSigned: $employerSigned, employeeSigned: $employeeSigned, duration: $duration, totalAmount: $totalAmount, isActive: $isActive, hasEnded: $hasEnded, paidUpAmount: $paidUpAmount, transactionAmountPerTransfer: $transactionAmountPerTransfer, collateral: $collateral, renew: $renew, status: $status, reminder20: $reminder20, reminder10: $reminder10, reminder5: $reminder5)';
  }

  @override
  bool operator ==(covariant ContractEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.contractId == contractId &&
      other.employerWalletId == employerWalletId &&
      other.employeeWalletId == employeeWalletId &&
      other.employerUsername == employerUsername &&
      other.employeeUsername == employeeUsername &&
      other.createdAt == createdAt &&
      other.startFrom == startFrom &&
      other.employerSigned == employerSigned &&
      other.employeeSigned == employeeSigned &&
      other.duration == duration &&
      other.totalAmount == totalAmount &&
      other.isActive == isActive &&
      other.hasEnded == hasEnded &&
      other.paidUpAmount == paidUpAmount &&
      other.transactionAmountPerTransfer == transactionAmountPerTransfer &&
      other.collateral == collateral &&
      other.renew == renew &&
      other.status == status &&
      other.reminder20 == reminder20 &&
      other.reminder10 == reminder10 &&
      other.reminder5 == reminder5;
  }

  @override
  int get hashCode {
    return contractId.hashCode ^
      employerWalletId.hashCode ^
      employeeWalletId.hashCode ^
      employerUsername.hashCode ^
      employeeUsername.hashCode ^
      createdAt.hashCode ^
      startFrom.hashCode ^
      employerSigned.hashCode ^
      employeeSigned.hashCode ^
      duration.hashCode ^
      totalAmount.hashCode ^
      isActive.hashCode ^
      hasEnded.hashCode ^
      paidUpAmount.hashCode ^
      transactionAmountPerTransfer.hashCode ^
      collateral.hashCode ^
      renew.hashCode ^
      status.hashCode ^
      reminder20.hashCode ^
      reminder10.hashCode ^
      reminder5.hashCode;
  }
}
