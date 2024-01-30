import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:talab/config/router/app_route.dart';
import 'package:talab/core/common/snackbar.dart';
import 'package:talab/features/auth/domain/entity/user_entity.dart';
import 'package:talab/features/splash/domain/use_case/splash_use_case.dart';
import '../../domain/use_case/auth_usecase.dart';
import '../state/auth_state.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(
    ref.read(authUseCaseProvider),
    ref.read(splashUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;
  final SplashUseCase _splashUseCase;

  AuthViewModel(this._authUseCase, this._splashUseCase)
      : super(AuthState.initial());

  Future<void> toggleAuthMode() async {
    state = state.copyWith(onLogin: !state.onLogin);
  }

  Future<void> toggleRole() async {
    state = state.copyWith(isEmployee: !state.isEmployee);
  }

  Future<void> registerStudent({
    required String username,
    required String fullname,
    required String password,
    required String gender,
    required DateTime dob,
    required String address,
    required String email,
    required String phone,
    String? image,
    required String documentImage,
    required String documentIdNumber,
    required String accountType,
    required String walletId,
    required BuildContext context,
  }) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.registerStudent(
        username: username,
        fullname: fullname,
        password: password,
        gender: gender,
        dob: dob,
        address: address,
        email: email,
        phone: phone,
        image: image ?? " ",
        documentImage: documentImage ?? " ",
        documentIdNumber: documentIdNumber,
        accountType: accountType,
        walletId: walletId);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(context, failure.error.toString());
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        showSnackBar(context, "Register Success");
      },
    );
  }

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.uploadProfileProfile(file!);
    data.fold((l) {
      state = state.copyWith(isLoading: false, error: l.error);
    }, (r) {
      state = state.copyWith(isLoading: false, error: null, imageName: r);
    });
  }

  Future<void> loginStudent(
      BuildContext context, String username, String password) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.loginStudent(username, password);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(context, failure.error.toString());
      },
      (success) {
        state = state.copyWith(
            isLoading: false, error: null, isLogin: true, loggedUser: success);
        showSnackBar(context, 'Log In Successfull!');
        Navigator.popAndPushNamed(context, AppRoute.dashboardRoute);
      },
    );
  }

  //logout
  Future<void> logout(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    var data = await _authUseCase.logout();
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(context, failure.error.toString());
      },
      (success) {
        state = state.copyWith(
            isLoading: false, error: null, isLogin: false, loggedUser: null);
        showSnackBar(context, 'Log Out Successfull!');
        Navigator.popAndPushNamed(context, AppRoute.loginregisterRoute);
      },
    );
  }

  Future<void> loginWithToken({biometrics = false}) async {
    state = state.copyWith(isLoading: true);
    var data = await _splashUseCase.loginWithToken(biometics: biometrics);
    print('something ${data.toString()}');
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
      },
      (success) {
        state = state.copyWith(
            isLoading: false, error: null, isLogin: true, loggedUser: success);
      },
    );
  }

  Future<void> checkDeviceSupportForBiometrics() async {
    final result = await _authUseCase.checkDeviceSupportForBiometrics();
    result.fold(
      (failure) {
        failure.error;
        state = state.copyWith(
          isLoading: false,
          supportBioMetricState: false,
        );
      },
      (r) async {
        final localAuth = LocalAuthentication();
        final List<BiometricType> avilableBiometrices =
            r ? await localAuth.getAvailableBiometrics() : [];
        state = state.copyWith(
          isLoading: false,
          supportBioMetricState: r,
          localAuth: localAuth,
          avilableBiometrices: avilableBiometrices,
        );
      },
    );
  }

  Future<void> authenticateWithBiometrics(
      {required BuildContext context}) async {
    try {
      bool isAuthorized = await state.localAuth!.authenticate(
        localizedReason: 'Test for auth',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      log('etaetaeta');
      log('allowloginwithbiometric ${state.allowLoginWithBiometric}');
      log(isAuthorized.toString());
      if (state.allowLoginWithBiometric && isAuthorized) {
        await _splashUseCase.loginWithToken(biometics: true);
        log('authorized login with biometric');

        Navigator.pushNamed(context, AppRoute.dashboardRoute);
      }
    } on PlatformException catch (e) {
      state = state.copyWith(
        error: e.message,
      );
    }
  }

  Future<void> allowLoginWithBiometric({required bool value}) async {
    state = state.copyWith(
      allowLoginWithBiometric: value,
    );
  }

  Future<void> deleteUserProfile({
    required String userID,
  }) async {
    state = state.copyWith(
      isLoading: true,
    );

    final result = await _authUseCase.deleteUserProfile(
      userID: userID,
    );
    log('view model hit');

    result.fold(
      (failure) {
        return state = state.copyWith(
          isLoading: false,
          error: failure.error.toString(),
        );
      },
      (r) {
        return state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }

  Future<void> updateUserProfile({
    required UserEntity user,
  }) async {
    state = state.copyWith(
      isLoading: true,
    );

    final result = await _authUseCase.updateUser(user: user);
    log('view model hit');

    result.fold(
      (failure) {
        return state = state.copyWith(
          isLoading: false,
          error: failure.error.toString(),
        );
      },
      (r) {
        return state = state.copyWith(
          isLoading: false,
          loggedUser: r,
        );
      },
    );
  }
}
