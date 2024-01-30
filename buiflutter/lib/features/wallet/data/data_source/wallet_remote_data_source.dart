import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/network/local/hive_service.dart';
import 'package:talab/features/wallet/data/model/wallet_hive_model.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../../../../core/shared_prefs/user_sharedprefs.dart';
import '../../domain/entity/wallet_entity.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      hiveService: ref.read(hiveServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider));
});

class WalletRemoteDataSource {
  final HttpService dio;
  final UserSharedPrefs userSharedPrefs;
  final HiveService hiveService ;

  WalletRemoteDataSource({required this.dio, required this.userSharedPrefs, required this.hiveService});

  Future<Either<Failure, WalletEntity>> getWalletById(String id) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);
      Response response = await dio.httpService.get(
        ApiEndpoints.getWalletById + id,
        options: Options(headers: {
          "Authorization": "Bearer ${token}"
        }),
      );
      print('response is : ${response.data['balance'].runtimeType}');
      // Save data to hive 
      hiveService.addWallet(WalletHiveModel.empty().toHiveModel(WalletEntity(
        walletId: response.data['_id'],
        lastActive: DateTime.parse(response.data['last_active']),
        balance: double.parse('${response.data['balance']}'),
      ),),);
      return Right(WalletEntity(
        walletId: response.data['_id'],
        lastActive: DateTime.parse(response.data['last_active']),

        balance: double.parse('${response.data['balance']}') ,
      ));
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.response?.data['error'],
          statuscode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, WalletEntity>> updateWalletBalance({
    required String id,
    required double balance,
  }) async {
    try {
      var tokenEither = await userSharedPrefs.getUserToken();
      String token = tokenEither.fold((l) => '', (r) => r);
      Response response = await dio.httpService.patch(
        ApiEndpoints.updateWalletBalance + id,
        data: {
          'balance': balance,
        },
        options: Options(headers: {
          "Authorization": "Bearer ${token}"
        }),
      );
      return Right(WalletEntity(
        walletId: response.data['_id'],
        lastActive: DateTime.parse(response.data['last_active']),
        balance: double.parse("${response.data['balance']}"),
      ));
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.response?.data['error'],
          statuscode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
