import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/core/common/dropdown.dart';
import 'package:intl/intl.dart';
import 'package:talab/core/common/snackbar.dart';
import 'package:talab/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';
import 'package:talab/features/contract/presentation/view_model/contract_view_model.dart';

class ContractDetailsView extends ConsumerStatefulWidget {
  const ContractDetailsView({super.key, required this.contract});

  final ContractEntity contract;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContractViewState();
}

class _ContractViewState extends ConsumerState<ContractDetailsView> {
  late List<String> employees = [];
  late DateTime startDateTime;
  late DateTime endDateTime;
  // controllers
  final toalAmountController = TextEditingController();
  final collateralController = TextEditingController();
  String? employee = '';

  Future<void> initialDataFetch() async {
    final contractViewModel = ref.read(contractViewModelProvider.notifier);
    await contractViewModel.getAllEmployees();

    final allEmployees = ref.watch(contractViewModelProvider).allEmployees;
    final ContractEntity selectedContracts = ref
        .watch(contractViewModelProvider)
        .userContractsByRoleAndID
        .where((element) => element.contractId == widget.contract.contractId)
        .toList()[0];
    employees = allEmployees.map((e) => e.username).toList();
    toalAmountController.text = selectedContracts.totalAmount.toString();
    collateralController.text = selectedContracts.collateral.toString();
    employee = selectedContracts.employeeUsername;

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

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd HH:mm");

    return Scaffold(
        appBar: AppBar(
          title: const Text('Contract Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //  Dropdown of employees
                if (employees.isEmpty) ...{
                  const Center(
                    child: Text('No employees found'),
                  )
                } else ...{
                  KDropdownFormField(
                    value: employee!,
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
                // Start date and Time
                SizedBox(
                  height: 60,
                  child: InkWell(
                    onTap: _showStartDateTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Date and Time',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        format.format(startDateTime),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // End date and Time
                SizedBox(
                  height: 60,
                  child: InkWell(
                    onTap: _showEndDateTimePicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select End and Time',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        format.format(endDateTime),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                // toal amount
                const SizedBox(
                  height: 20,
                ),
                // Textfield for total amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: toalAmountController,
                  decoration: InputDecoration(
                    labelText: 'Total Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // collateral
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: collateralController,
                  decoration: InputDecoration(
                    labelText: 'Collateral Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Create contract button
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
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
                    contractViewModel.updateContract(
                      contract: widget.contract.copyWith(
                        employeeUsername: employee,
                        employerWalletId: employerWalletID,
                        employeeWalletId: employeeWalletID,
                        totalAmount: double.parse(toalAmountController.text),
                        collateral: double.parse(collateralController.text),
                      ),
                      contractID: widget.contract.contractId,
                    );
                    showSnackBar(context, 'Contract Created!');
                  },
                  child: const Text('Update Contract'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.contract.status != 'expired'
                        ? ElevatedButton(
                            onPressed: () {
                              final employerWalletID = ref
                                  .watch(authViewModelProvider)
                                  .loggedUser!
                                  .walletId;

                              final employeeWalletID = ref
                                  .watch(contractViewModelProvider)
                                  .allEmployees
                                  .firstWhere(
                                      (element) => element.username == employee)
                                  .walletId;

                              final contractViewModel =
                                  ref.read(contractViewModelProvider.notifier);
                              contractViewModel.updateContract(
                                contract: widget.contract.copyWith(
                                  status: 'expired',
                                ),
                                contractID: widget.contract.contractId,
                              );
                              showSnackBar(context, 'Contract expired');
                            },
                            child:
                                // Text('Stop')
                                Icon(
                              Icons.stop,
                              color: Colors.red,
                              size: 30,
                            ),
                          )
                        : SizedBox.shrink(),
                    widget.contract.status != "paused" &&
                            widget.contract.status != 'expired'
                        ? ElevatedButton(
                            onPressed: () {
                              final employerWalletID = ref
                                  .watch(authViewModelProvider)
                                  .loggedUser!
                                  .walletId;

                              final employeeWalletID = ref
                                  .watch(contractViewModelProvider)
                                  .allEmployees
                                  .firstWhere(
                                      (element) => element.username == employee)
                                  .walletId;

                              final contractViewModel =
                                  ref.read(contractViewModelProvider.notifier);
                              contractViewModel.updateContract(
                                contract: widget.contract.copyWith(
                                  status: 'paused',
                                ),
                                contractID: widget.contract.contractId,
                              );
                              showSnackBar(context, 'Contract paused');
                              setState(() {});
                            },
                            child: Icon(
                              Icons.pause,
                              color: Colors.red,
                              size: 30,
                            )
                            //  Text('Pasue')
                            ,
                          )
                        : SizedBox.shrink(),
                    widget.contract.status != 'expired' &&
                            widget.contract.status != 'active'
                        ? ElevatedButton(
                            onPressed: () {
                              final employerWalletID = ref
                                  .watch(authViewModelProvider)
                                  .loggedUser!
                                  .walletId;

                              final employeeWalletID = ref
                                  .watch(contractViewModelProvider)
                                  .allEmployees
                                  .firstWhere(
                                      (element) => element.username == employee)
                                  .walletId;

                              final contractViewModel =
                                  ref.read(contractViewModelProvider.notifier);
                              contractViewModel.updateContract(
                                contract: widget.contract.copyWith(
                                  status: 'active',
                                ),
                                contractID: widget.contract.contractId,
                              );
                              showSnackBar(context, 'Contract resumed');
                              setState(() {});
                            },
                            child: const
                                // Text('Resume')
                                Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                              size: 30,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),

                // Delete contract button
                ElevatedButton(
                  onPressed: () async {
                    final contractViewModel =
                        ref.read(contractViewModelProvider.notifier);
                    await contractViewModel.deleteContract(
                      contractId: widget.contract.contractId,
                    );
                    Navigator.pop(context);
                    showSnackBar(context, 'Contract deleted');
                  },
                  child: const
                      // Text('Delete Contract')
                      Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
