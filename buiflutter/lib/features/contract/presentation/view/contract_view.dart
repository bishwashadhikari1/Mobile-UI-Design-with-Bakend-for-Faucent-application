import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:talab/core/common/dropdown.dart';
import 'package:intl/intl.dart';
import 'package:talab/core/common/snackbar.dart';
import 'package:talab/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:talab/features/contract/presentation/view/bargraph_painter.dart';
import 'package:talab/features/contract/presentation/view_model/contract_view_model.dart';

import '../../../dashboard/presentation/widgets/contract_details.dart';

class ContractView extends ConsumerStatefulWidget {
  const ContractView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContractViewState();
}

class _ContractViewState extends ConsumerState<ContractView> {
  late List<String> employees = [];
  late DateTime startDateTime;
  late DateTime endDateTime;

  Future<void> initialDataFetch() async {
    final contractViewModel = ref.read(contractViewModelProvider.notifier);
    await contractViewModel.getAllEmployees();

    final allEmployees = ref.watch(contractViewModelProvider).allEmployees;
    employees = allEmployees.map((e) => e.username).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    startDateTime = DateTime.now();
    endDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialDataFetch();
    });
  }

  Future<void> _showStartDateTimePicker() async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: startDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(startDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          startDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _showEndDateTimePicker() async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: endDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(endDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          endDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  bool _showForm = false; // to control the visibility of the form

// controllers
  final toalAmountController = TextEditingController();
  final collateralController = TextEditingController();
  String? employee = '';

  Widget labeledTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColorConstant.black,
            // fontWeight: FontWeight.w500,
            fontFamily: 'sf-semibold',
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final contracts =
        ref.watch(contractViewModelProvider).userContractsByRoleAndID;

    final authState = ref.watch(authViewModelProvider);

    final format = DateFormat("yyyy-MM-dd HH:mm");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contracts',
            style: TextStyle(
                color: AppColorConstant.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "sf-bold")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorConstant.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showForm =
                          true; // show the form when the button is pressed
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline_rounded,
                          color: AppColorConstant.white),
                      const SizedBox(width: 8),
                      const Text('Create Contract',
                          style: TextStyle(
                            color: AppColorConstant.white,
                            fontSize: 16,
                            fontFamily: "sf-medium",
                          )),
                    ],
                  ),
                ),
              ),
              if (_showForm) ...[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showForm =
                            false; // hide the form when the X button is pressed
                      });
                    },
                  ),
                ),
                labeledTextField("Select an employee"),
                // Dropdown of employees
                if (employees.isEmpty) ...{
                  const Center(
                    child: Text('No employees found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "sf-medium",
                        )),
                  )
                } else ...{
                  KDropdownFormField(
                    value: employees[0],
                    onChanged: (value) {
                      setState(() {
                        employee = value;
                      });
                    },
                    options: employees,
                  )
                },
                const SizedBox(
                  height: 20,
                ),
                labeledTextField("Select start date and time of contract"),

                // Start date and Time
                SizedBox(
                  height: 60,
                  child: InkWell(
                    onTap: _showStartDateTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select Date and Time',
                        hintStyle: TextStyle(
                            color: AppColorConstant.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sf-medium"),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: AppColorConstant.blue,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        format.format(startDateTime),
                        style: TextStyle(fontSize: 16, fontFamily: "sf-medium"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                labeledTextField("Select end date and time of contract"),
                // End date and Time
                SizedBox(
                  height: 60,
                  child: InkWell(
                    onTap: _showEndDateTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select End and Time',
                        hintStyle: TextStyle(
                            color: AppColorConstant.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "sf-medium"),
                        prefixIcon: Icon(Icons.calendar_today,
                            color: AppColorConstant.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        format.format(endDateTime),
                        style: TextStyle(fontSize: 16, fontFamily: "sf-medium"),
                      ),
                    ),
                  ),
                ),
                // toal amount
                const SizedBox(
                  height: 20,
                ),
                labeledTextField("Total Amount of contract"),
                // Textfield for total amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: toalAmountController,
                  decoration: InputDecoration(
                    hintText: 'Total Amount',
                    hintStyle: TextStyle(
                        color: AppColorConstant.black,
                        fontSize: 16,
                        fontFamily: "sf-medium"),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                labeledTextField("Collateral amount"),
                // collateral
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: collateralController,
                  decoration: InputDecoration(
                    hintText: 'Collateral Amount',
                    hintStyle: TextStyle(
                        color: AppColorConstant.black,
                        fontSize: 16,
                        fontFamily: "sf-medium"),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Create contract button
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final employerWalletID =
                          ref.watch(authViewModelProvider).loggedUser!.walletId;

                      final employeeWalletID = ref
                          .watch(contractViewModelProvider)
                          .allEmployees
                          .firstWhere((element) => element.username == employee)
                          .walletId;

                      final contractViewModel =
                          ref.read(contractViewModelProvider.notifier);
                      contractViewModel.createContract(
                        employerWalletID: employerWalletID,
                        employeeWalletID: employeeWalletID,
                        collateral: int.parse(collateralController.text),
                        startFrom: startDateTime,
                        endFrom: endDateTime,
                        role: 'employer',
                        totalAmount: int.parse(toalAmountController.text),
                      );
                      showSnackBar(context, 'Contract created successfully');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorConstant.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Create Contract',
                        style: TextStyle(
                          color: AppColorConstant.white,
                          fontSize: 16,
                          fontFamily: "sf-medium",
                        )),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 1),
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: contracts.length,
              //     itemBuilder: (context, index) {
              //       final contract = contracts[index];
              //       final progress =
              //           contract.paidUpAmount / contract.totalAmount;
              //       final progressString =
              //           '${(progress * 100).toStringAsFixed(1)}%'; // Shows the percentage with one decimal place

              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => ContractDetailsView(
              //                 contract: contract,
              //               ),
              //             ),
              //           );
              //         },
              //         child: Container(
              //           margin: const EdgeInsets.symmetric(vertical: 4),
              //           padding: const EdgeInsets.all(8),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 spreadRadius: 1,
              //                 blurRadius: 6,
              //                 offset: Offset(0, 3),
              //               ),
              //             ],
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     contract.employeeUsername,
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 16,
              //                     ),
              //                   ),
              //                   Container(
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 12, vertical: 6),
              //                     decoration: BoxDecoration(
              //                       color: Colors.blue,
              //                       borderRadius: BorderRadius.circular(20),
              //                     ),
              //                     child: Text(
              //                       progressString,
              //                       style: TextStyle(color: Colors.white),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 8),
              //               Stack(
              //                 children: [
              //                   Container(
              //                     height: 20,
              //                     decoration: BoxDecoration(
              //                       color: Colors.grey[200],
              //                       borderRadius: BorderRadius.circular(10),
              //                     ),
              //                   ),
              //                   LayoutBuilder(
              //                     builder: (context, constraints) {
              //                       return Container(
              //                         height: 20,
              //                         width: constraints.maxWidth * progress,
              //                         decoration: BoxDecoration(
              //                           color: Colors.blue,
              //                           borderRadius: BorderRadius.circular(10),
              //                         ),
              //                       );
              //                     },
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 4),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     'NPR ${contract.paidUpAmount.toStringAsFixed(1)}',
              //                     style: TextStyle(
              //                       color: AppColorConstant.black,
              //                       fontSize: 14,
              //                     ),
              //                   ),
              //                   Text(
              //                     'NPR ${contract.totalAmount.toStringAsFixed(1)}',
              //                     style: TextStyle(
              //                       color: Colors.grey,
              //                       fontSize: 14,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // )

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    final contract = contracts[index];
                    final progress =
                        contract.paidUpAmount / contract.totalAmount;
                    final progressString =
                        '${(progress * 100).toStringAsFixed(1)}%'; // Shows the percentage with one decimal place

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractDetailsView(
                              contract: contract,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // User Icon
                                Icon(Icons.person_2_rounded,
                                    size:
                                        32), // Replace with your user icon asset
                                SizedBox(width: 8),
                                // Employee Username
                                Text(
                                  contract.employeeUsername,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(), // This will push the bar graph and the percentage to the right
                                // Decorative Bar Graph
                                CustomPaint(
                                  size: Size(100,
                                      24), // You can change the size to fit your needs
                                  painter: BarGraphPainter(
                                    value: contract.paidUpAmount,
                                    maxValue: 300000,
                                    divisions: 5,
                                  ),
                                ),

                                SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    progressString,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'NPR ${contract.paidUpAmount.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'NPR ${contract.totalAmount.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: AppColorConstant.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColorConstant.blue),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 1),
              //   child: Column(
              //     children: [
              //       ListView.builder(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         itemCount: contracts.length,
              //         itemBuilder: (context, index) {
              //           return InkWell(
              //             onTap: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) {
              //                     return ContractDetailsView(
              //                       contract: contracts[index],
              //                     );
              //                   },
              //                 ),
              //               );
              //             },
              //             child: buildListItem(
              //                 contracts[index].employeeUsername,
              //                 'Progress',
              //                 // THE PAID UP AND TOTAL AMOUNT SHOULD ONLY BE UPTO FIRST DECIMAL PLACE

              //                 '${contracts[index].paidUpAmount.toString()}/${contracts[index].totalAmount.toString()}',
              //                 (contracts[index].paidUpAmount /
              //                     contracts[index].totalAmount)),
              //           );
              //         },
              //       )
              //     ],
              //   ),
              // ),
            ]),
          ),
        ),
      ),
    );
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
