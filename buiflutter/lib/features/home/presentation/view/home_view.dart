import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';
import 'package:talab/features/contract/presentation/view_model/contract_view_model.dart';
import 'package:talab/features/dashboard/presentation/widgets/contract_details.dart';
import 'package:talab/features/home/presentation/view/contractcardChart.dart';
import 'package:talab/features/home/presentation/view/walletBalanceChart.dart';

import '../../../../config/router/app_route.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../wallet/presentation/viewmodel/wallet_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late List<ContractEntity> contracts = [];
  late final PermissionStatus status;
  void initalDataFetch() async {
    status = await Permission.sensors.status;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    bool isWithdrawActive = true;
    return StreamBuilder<int>(
        stream: Light().lightSensorStream,
        initialData: 0,
        builder: (context, snapshot) {
          if (snapshot.data == 0) {
            log('Light sensor not detected in this device');
          } else if (snapshot.data! < 2) {
            SystemNavigator.pop();
          }

          log(snapshot.data.toString());

          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: AppColorConstant.white,
            //   elevation: 0,
            //   leading: IconButton(
            //     icon: Icon(
            //       Icons.menu,
            //       color: AppColorConstant.black,
            //     ),
            //     onPressed: () {},
            //   ),
            //   actions: [
            //     IconButton(
            //       icon: Icon(
            //         Icons.search,
            //         color: AppColorConstant.black,
            //       ),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColorConstant.white,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, ${authState.loggedUser?.fullname} ',
                                      style: TextStyle(
                                          color: AppColorConstant.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "sf-bold"),
                                    ),
                                    Text("Welcome back to Talab",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontFamily: "sf-medium")),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.notifications,
                                    color: AppColorConstant.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColorConstant.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 120),
                            Padding(
                              padding: EdgeInsets.only(left: 28, right: 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: isWithdrawActive
                                                ? AppColorConstant.blue
                                                : AppColorConstant
                                                    .lightgrey, // Background color
                                            foregroundColor: isWithdrawActive
                                                ? AppColorConstant.white
                                                : AppColorConstant
                                                    .blue, // Text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            fixedSize:
                                                Size(screenwidth * 0.4, 20)),
                                        onPressed: () {
                                          setState(() {
                                            isWithdrawActive = true;
                                          });
                                          Navigator.pushNamed(
                                              context, AppRoute.withdrawRoute);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.remove_circle_outline,
                                              color: AppColorConstant.white,
                                            ),
                                            const Text('Withdraw'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: !isWithdrawActive
                                                ? AppColorConstant.blue
                                                : AppColorConstant
                                                    .lightgrey, // Background color
                                            foregroundColor: !isWithdrawActive
                                                ? AppColorConstant.white
                                                : AppColorConstant
                                                    .blue, // Text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            fixedSize:
                                                Size(screenwidth * 0.4, 20)),
                                        onPressed: () {
                                          setState(() {
                                            isWithdrawActive = false;
                                          });
                                          Navigator.pushNamed(
                                              context, AppRoute.addMoneyRoute);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: AppColorConstant.blue,
                                            ),
                                            const Text('Deposit'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pushNamed(
                                          context, AppRoute.contractRoute);
                                    },
                                    child: Text(
                                      'Contracts  ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColorConstant.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "sf-bold",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: contracts.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ContractDetailsView(
                                                    contract: contracts[index],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: ContractListItem(
                                            name: contracts[index]
                                                .employeeUsername,
                                            role: 'Backend developer',
                                            amount:
                                                contracts[index].totalAmount,
                                            percentageChange:
                                                (contracts[index].paidUpAmount /
                                                        contracts[index]
                                                            .totalAmount) *
                                                    100,
                                            todayAmount:
                                                contracts[index].totalAmount,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    (authState.loggedUser?.accountType ==
                                            'employer')
                                        ? ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                            label: const Text(
                                              'Contract',
                                            ),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.15, // adjust this as needed
                  left: 30,
                  right: 30,
                  child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.325, // adjust this as needed
                    decoration: BoxDecoration(
                      color: AppColorConstant.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Total asset value',
                                  style: TextStyle(
                                      color: AppColorConstant.darkgrey,
                                      fontSize: 14,
                                      fontFamily: "sf-medium"),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.bar_chart_outlined,
                                  color: AppColorConstant.white,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'NPR ${walletState.balance ?? 0}',
                              style: TextStyle(
                                color: AppColorConstant.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "sf-bold",
                                fontSize: 24,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              height: 120,
                              child: WalletBalanceChart.withSampleData(),
                            ),
                            const SizedBox(height: 10),

                            // WalletBalanceChart.withSampleData(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildListItem(
      String title, String subtitle, String amount, double progress) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(
        title,
        style: TextStyle(color: AppColorConstant.black, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            amount,
            style: TextStyle(
              color: AppColorConstant.black,
              fontWeight: FontWeight.w400,
              fontSize: 21,
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 10, // set a specific height for the progress indicator
            child: LinearProgressIndicator(
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
