import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/failure/failure.dart';
import 'package:talab/core/network/local/hive_service.dart';
import 'package:talab/core/shared_prefs/user_sharedprefs.dart';
import 'package:talab/features/wallet/data/model/wallet_hive_model.dart';
import 'package:talab/features/wallet/domain/entity/wallet_entity.dart';



final walletLocalDataSourceProvider = Provider<WalletLocalDataSource>((ref) {
  return WalletLocalDataSource(
      hiveService: ref.read(hiveServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});
class WalletLocalDataSource {
  final UserSharedPrefs userSharedPrefs;
  final HiveService hiveService ;
  WalletLocalDataSource({
    required this.userSharedPrefs,
    required this.hiveService,
  });

  Future<Either<Failure, WalletEntity>> getWalletById(String walletID, ) async{
    try {
      var wallet = await hiveService.getWalletById(walletID);
      return Right(wallet.toEntity());
      
    } catch (e) {
      return Left(Failure(error: e.toString(), statuscode: '0'));
    }
  }
}
