// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';

class ContractState {
  final bool isLoading;
  final String? error;
  final List<ContractEntity> userContractsByRoleAndID;
  final List<UserEntity> allEmployees;
  ContractState({
    required this.isLoading,
    this.error,
    required this.userContractsByRoleAndID,
    required this.allEmployees,
  });

  factory ContractState.initial() {
    return ContractState(
      isLoading: false,
      error: null,
      userContractsByRoleAndID: <ContractEntity>[],
      allEmployees: <UserEntity>[],
    );
  }

  ContractState copyWith({
    bool? isLoading,
    String? error,
    List<ContractEntity>? userContractsByRoleAndID,
    List<UserEntity>? allEmployees,
  }) {
    return ContractState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userContractsByRoleAndID:
          userContractsByRoleAndID ?? this.userContractsByRoleAndID,
      allEmployees: allEmployees ?? this.allEmployees,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLoading': isLoading,
      'error': error,
      'userContractsByRoleAndID':
          userContractsByRoleAndID.map((x) => x.toMap()).toList(),
      'allEmployees': allEmployees.map((x) => x.toMap()).toList(),
    };
  }

  factory ContractState.fromMap(Map<String, dynamic> map) {
    return ContractState(
      isLoading: map['isLoading'] as bool,
      error: map['error'] != null ? map['error'] as String : null,
      userContractsByRoleAndID: List<ContractEntity>.from(
        (map['userContractsByRoleAndID'] as List<int>).map<ContractEntity>(
          (x) => ContractEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      allEmployees: List<UserEntity>.from(
        (map['allEmployees'] as List<int>).map<UserEntity>(
          (x) => UserEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContractState.fromJson(String source) =>
      ContractState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContractState(isLoading: $isLoading, error: $error, userContractsByRoleAndID: $userContractsByRoleAndID, allEmployees: $allEmployees)';
  }

  @override
  bool operator ==(covariant ContractState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.error == error &&
        listEquals(other.userContractsByRoleAndID, userContractsByRoleAndID) &&
        listEquals(other.allEmployees, allEmployees);
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        userContractsByRoleAndID.hashCode ^
        allEmployees.hashCode;
  }
}
