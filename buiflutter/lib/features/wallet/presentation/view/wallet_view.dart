import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';
import 'package:talab/features/contract/presentation/view_model/contract_view_model.dart';
import 'package:talab/features/dashboard/presentation/widgets/contract_details.dart';
import 'package:talab/features/wallet/presentation/state/wallet_state.dart';

import '../../../../config/router/app_route.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../wallet/presentation/viewmodel/wallet_view_model.dart';

class WalletView extends ConsumerStatefulWidget {
  const WalletView({super.key});

  @override
  ConsumerState<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletView> {
  late List<ContractEntity> contracts = [];

  void initalDataFetch() async {
    final loggedUser = await ref.watch(authViewModelProvider).loggedUser;
    log(loggedUser.toString());
    ref.watch(contractViewModelProvider.notifier).filterContractsByRoleAndId(
        role: loggedUser!.accountType, walletId: loggedUser.walletId);

    setState(() {
      contracts = ref.watch(contractViewModelProvider).userContractsByRoleAndID;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initalDataFetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    final walletState = ref.watch(walletViewModelProvider);

    bool isPortrait = screenheight > screenwidth;
    double childAspectRatio = isPortrait ? 2 / 1.41 : 2.5 / 1;
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColorConstant.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height *
                  0.15, // adjust this as needed
              left: 30,
              right: 30,
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.27, // adjust this as needed
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 249, 108, 155),
                      Color.fromARGB(255, 247, 167, 49),
                      Color.fromARGB(255, 247, 227, 49),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'WALLET',
                          style: TextStyle(
                            color: AppColorConstant.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'NPR ${walletState.balance ?? 0}',
                          style: TextStyle(
                            color: AppColorConstant.black,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: AppColorConstant.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.withdrawRoute);
                              },
                              child: const Text('Withdraw'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.addMoneyRoute);
                              },
                              child: const Text('Add Money'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
