import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/wallet_entity.dart';
import '../repository/wallet_repository.dart';

final walletUseCaseProvider = Provider((ref) {
  return WalletUseCase(
    ref.read(walletRepositoryProvider),
  );
});

class WalletUseCase {
  final IWalletRepository _walletRepository;

  WalletUseCase(this._walletRepository);

  Future<Either<Failure, WalletEntity>> getWalletById(String id) async {

    print('assas: ${await _walletRepository.getWalletById(id)}');
    return await _walletRepository.getWalletById(id);

  }

  Future<Either<Failure, WalletEntity>> updateWalletBalance({
    required String id,
    required double balance,
  }) async {
    return await _walletRepository.updateWalletBalance(id: id, balance: balance);
  }
}
