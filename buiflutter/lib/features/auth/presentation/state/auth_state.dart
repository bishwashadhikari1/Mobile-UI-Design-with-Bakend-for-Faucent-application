// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:local_auth/local_auth.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? imageName;
  final bool? isLogin;
  final UserEntity? loggedUser;
  final bool onLogin;
  final bool isEmployee;
  final bool supportBioMetricState;
  final LocalAuthentication? localAuth;
  final List<BiometricType> avilableBiometrices;
  final bool allowLoginWithBiometric;

  AuthState({
    required this.isLoading,
    this.error,
    this.imageName,
    this.isLogin,
    this.loggedUser,
    required this.onLogin,
    required this.isEmployee,
    required this.supportBioMetricState,
    this.localAuth,
    required this.avilableBiometrices,
    required this.allowLoginWithBiometric,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      error: null,
      imageName: null,
      isLogin: null,
      loggedUser: null,
      onLogin: true,
      isEmployee: false,
      supportBioMetricState: false,
      avilableBiometrices: [],
      allowLoginWithBiometric: false,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? imageName,
    bool? isLogin,
    UserEntity? loggedUser,
    bool? onLogin,
    bool? isEmployee,
    bool? supportBioMetricState,
    LocalAuthentication? localAuth,
    List<BiometricType>? avilableBiometrices,
    bool? allowLoginWithBiometric,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
      isLogin: isLogin ?? this.isLogin,
      loggedUser: loggedUser ?? this.loggedUser,
      onLogin: onLogin ?? this.onLogin,
      isEmployee: isEmployee ?? this.isEmployee,
      supportBioMetricState:
          supportBioMetricState ?? this.supportBioMetricState,
      localAuth: localAuth ?? this.localAuth,
      avilableBiometrices: avilableBiometrices ?? this.avilableBiometrices,
      allowLoginWithBiometric:
          allowLoginWithBiometric ?? this.allowLoginWithBiometric,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, error: $error, imageName: $imageName, isLogin: $isLogin, loggedUser: $loggedUser, onLogin: $onLogin, isEmployee: $isEmployee, supportBioMetricState: $supportBioMetricState, localAuth: $localAuth, avilableBiometrices: $avilableBiometrices, allowLoginWithBiometric: $allowLoginWithBiometric)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLoading': isLoading,
      'error': error,
      'imageName': imageName,
      'isLogin': isLogin,
      'loggedUser': loggedUser?.toMap(),
      'onLogin': onLogin,
      'isEmployee': isEmployee,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      isLoading: map['isLoading'] as bool,
      error: map['error'] != null ? map['error'] as String : null,
      imageName: map['imageName'] != null ? map['imageName'] as String : null,
      isLogin: map['isLogin'] != null ? map['isLogin'] as bool : null,
      loggedUser: map['loggedUser'] != null
          ? UserEntity.fromMap(map['loggedUser'] as Map<String, dynamic>)
          : null,
      onLogin: map['onLogin'] as bool,
      isEmployee: map['isEmployee'] as bool,
      supportBioMetricState: map['supportBioMetricState'] as bool,
      localAuth: map['localAuth'] as LocalAuthentication?,
      avilableBiometrices: map['avilableBiometrices'] as List<BiometricType>,
      allowLoginWithBiometric: map['allowLoginWithBiometric'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.error == error &&
        other.imageName == imageName &&
        other.isLogin == isLogin &&
        other.loggedUser == loggedUser &&
        other.onLogin == onLogin &&
        other.isEmployee == isEmployee;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        imageName.hashCode ^
        isLogin.hashCode ^
        loggedUser.hashCode ^
        onLogin.hashCode ^
        isEmployee.hashCode;
  }
}
