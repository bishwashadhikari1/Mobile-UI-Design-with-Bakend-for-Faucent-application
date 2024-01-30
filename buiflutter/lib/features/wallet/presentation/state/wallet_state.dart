class WalletState {
  final bool isLoading;
  final String? error;
  String? walletId;
  final double? balance;

  WalletState({
    required this.isLoading,
    this.error,
    this.walletId,
    this.balance,
  });

  factory WalletState.initial() {
    return WalletState(
      isLoading: false,
      error: null,
      walletId: null,
      balance: null,
    );
  }

  WalletState copyWith({
    bool? isLoading,
    String? error,
    String? walletId,
    double? balance,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      walletId: walletId ?? this.walletId,
      balance: balance ?? this.balance,
    );
  }

  @override
  String toString() =>
      'WalletState(isLoading: $isLoading, error: $error, walletId: $walletId, balance: $balance)';

  void getWalletById(String s) {}
}
