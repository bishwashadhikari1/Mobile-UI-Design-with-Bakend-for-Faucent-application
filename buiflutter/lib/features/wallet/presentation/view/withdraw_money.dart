import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/router/app_route.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/features/wallet/presentation/view/slide.dart';
import 'package:talab/features/wallet/presentation/view/withdraw_success.dart';

import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../viewmodel/wallet_view_model.dart';

final currentUserProvider = StateProvider<UserEntity?>((ref) {
  final authViewModel = ref.watch(authViewModelProvider);
  return authViewModel.loggedUser;
});

class WithdrawMoneyView extends ConsumerStatefulWidget {
  const WithdrawMoneyView({Key? key}) : super(key: key);

  @override
  ConsumerState<WithdrawMoneyView> createState() => _WithdrawMoneyViewState();
}

class _WithdrawMoneyViewState extends ConsumerState<WithdrawMoneyView> {
  final TextEditingController _controller = TextEditingController();
  bool _showBalance = true;

  void getWalletNow() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletState = ref.read(walletViewModelProvider.notifier);
      final currentUser = ref.watch(currentUserProvider);
      print('wallet: ${currentUser}');
      walletState.getWalletById('${currentUser!.walletId}');
    });
  }

  @override
  void initState() {
    super.initState();
    getWalletNow();
  }

  int? selectedCardIndex;
  String getSelectedDestination() {
    switch (selectedCardIndex) {
      case 0:
        return 'eSewa';
      case 1:
        return 'Khalti';
      case 2:
        return 'Connect IPS';
      default:
        return 'Unknown'; // Default or error case
    }
  }

  Widget buildListedCard() {
    final List<Map<String, dynamic>> cardData = [
      {'image': 'assets/images/esewa.png'},
      {'image': 'assets/images/khalti.png'},
      {'image': 'assets/images/ips.png'},
    ];
    return SizedBox(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cardData.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedCardIndex;
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCardIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: AppColorConstant.white,
                  elevation: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColorConstant.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: AppColorConstant.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: isSelected
                            ? AppColorConstant.blue
                            : AppColorConstant.white,
                        width: 3.0,
                      ),
                    ),
                    height: 72.75,
                    width: 100,
                    child: Stack(
                      children: [
                        Image.asset(cardData[index]['image'],
                            fit: BoxFit.cover),
                        if (isSelected)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Icon(Icons.check_circle, color: Colors.blue),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletViewModel = ref.watch(walletViewModelProvider.notifier);
    final walletState = ref.watch(walletViewModelProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColorConstant.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.dashboardRoute);
          },
        ),
        title: Text('Withdraw', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColorConstant.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: authViewModel.isLoading || walletState.balance == null
              ? CircularProgressIndicator()
              : authViewModel.error != null
                  ? Text('Error: ${authViewModel.error}')
                  : currentUser != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              color: AppColorConstant.black,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Balance: ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        (_showBalance
                                            ? '${walletState.balance}'
                                            : 'xxxxx.xx'),
                                        style: TextStyle(
                                            fontSize: 32, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _showBalance
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColorConstant.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showBalance = !_showBalance;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: AppColorConstant.black,
                              height: screenHeight * 0.735,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Set Amount",
                                        style: TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "sf-medium"),
                                      ),
                                      Text(
                                        "How much would you like to withdraw?",
                                        style: TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "sf-regular",
                                            color: Colors.grey),
                                      ),
                                      SizedBox(height: 20),
                                      TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          labelText: "NPR ",
                                          labelStyle: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "sf-regular",
                                            color: AppColorConstant.black,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Withdraw From",
                                        style: TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "sf-medium",
                                            color: AppColorConstant.black),
                                      ),
                                      buildListedCard(),
                                      SizedBox(height: 105),
                                      SliderButton(
                                        text: "Slide to withdraw",
                                        onSlided: () async {
                                          double withdrawalAmount =
                                              double.tryParse(
                                                      _controller.text) ??
                                                  0.0;
                                          if (walletState.balance! >=
                                              withdrawalAmount) {
                                            double updatedBalance = walletState
                                                    .balance! -
                                                withdrawalAmount; // It's safe to use the null check operator here now
                                            await walletViewModel
                                                .updateWalletBalance(
                                                    currentUser.walletId,
                                                    updatedBalance);
                                            _controller.clear();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WithdrawSuccessView(
                                                  amount: withdrawalAmount,
                                                  destination:
                                                      getSelectedDestination(),
                                                  transactionTime:
                                                      DateTime.now().toString(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Insufficient funds!'),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
