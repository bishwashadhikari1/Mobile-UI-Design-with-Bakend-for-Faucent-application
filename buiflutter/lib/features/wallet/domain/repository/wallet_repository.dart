import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/wallet_remote_repo.dart';
import '../../domain/entity/wallet_entity.dart';

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  return ref.read(walletRemoteRepositoryProvider);
});

abstract class IWalletRepository {
  Future<Either<Failure, WalletEntity>> getWalletById(String id);
  Future<Either<Failure, WalletEntity>> updateWalletBalance({
    required String id,
    required double balance,
  });
}
