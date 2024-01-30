class WalletEntity {
  final String walletId;
  final DateTime lastActive;
  final double balance;

  WalletEntity({
    required this.walletId,
    required this.lastActive,
    required this.balance,
  });

  @override
  String toString() {
    return 'WalletId: $walletId, LastActive: $lastActive, Balance: $balance ';
  }
}
