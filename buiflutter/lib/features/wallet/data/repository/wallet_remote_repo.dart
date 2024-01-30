import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/features/wallet/data/data_source/wallet_local_data_source.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/wallet_entity.dart';
import '../../domain/repository/wallet_repository.dart';
import '../data_source/wallet_remote_data_source.dart';

final walletRemoteRepositoryProvider = Provider<WalletRemoteRepository>((ref) {
  return WalletRemoteRepository(
    walletRemoteDataSourceProvider: ref.read(walletRemoteDataSourceProvider),
    walletLocalDataSourceProvider: ref.read(walletLocalDataSourceProvider),

  );
});

class WalletRemoteRepository implements IWalletRepository {
  final WalletRemoteDataSource walletRemoteDataSourceProvider;
  final WalletLocalDataSource walletLocalDataSourceProvider;

  WalletRemoteRepository({
    required this.walletRemoteDataSourceProvider,
    required this.walletLocalDataSourceProvider,
  });

  @override
  Future<Either<Failure, WalletEntity>> getWalletById(String id) async{

    final connectivity =await  Connectivity().checkConnectivity() == ConnectivityResult.wifi;

    if(connectivity){
      return await walletRemoteDataSourceProvider.getWalletById(id);
    }else{
return await walletLocalDataSourceProvider.getWalletById(id);
    }

  }

  @override
  Future<Either<Failure, WalletEntity>> updateWalletBalance({
    required String id,
    required double balance,
  }) async {

    
    return await walletRemoteDataSourceProvider.updateWalletBalance(id: id, balance: balance);
  }
}
