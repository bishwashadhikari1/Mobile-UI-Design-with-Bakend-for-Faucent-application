import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/features/auth/domain/use_case/auth_usecase.dart';

import '../../domain/usecase/wallet_usecase.dart';
import '../state/wallet_state.dart';


final walletViewModelProvider = StateNotifierProvider<WalletViewModel, WalletState>((ref) {
  final walletUseCase = ref.watch(walletUseCaseProvider);
  return WalletViewModel(walletUseCase);
});

class WalletViewModel extends StateNotifier<WalletState> {
  final WalletUseCase walletUseCase;

  WalletViewModel(this.walletUseCase) : super(WalletState.initial());

  Future<void> getWalletById(String id) async {
    state = state.copyWith(isLoading: true);
    final result = await walletUseCase.getWalletById(id);

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error.toString()),
      (wallet) => state = state.copyWith(isLoading: false, walletId: wallet.walletId, balance: wallet.balance),
    );
  }

  Future<void> updateWalletBalance(String id, double balance) async {
    state = state.copyWith(isLoading: true);

    final result = await walletUseCase.updateWalletBalance(id: id, balance: balance);

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error.toString()),
      (wallet) => state = state.copyWith(isLoading: false, walletId: wallet.walletId, balance: wallet.balance),
    );
  }
}
