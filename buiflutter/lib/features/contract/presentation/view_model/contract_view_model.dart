// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/features/contract/domain/entity/contract_entity.dart';

import 'package:talab/features/contract/domain/usecase/contract_usecase.dart';
import 'package:talab/features/contract/presentation/state/contract_state.dart';

final contractViewModelProvider =
    StateNotifierProvider<ContractVewModel, ContractState>((ref) {
  final contractUseCase = ref.read(contractUseCaseProvider);
  return ContractVewModel(contractUseCase);
});

class ContractVewModel extends StateNotifier<ContractState> {
  final ContractUseCase contractUseCase;
  ContractVewModel(
    this.contractUseCase,
  ) : super(ContractState.initial());

  Future<void> filterContractsByRoleAndId({
    required String role,
    required String walletId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await contractUseCase.filterContractsByRoleAndId(
        role: role, walletId: walletId);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (contracts) => state = state.copyWith(
        isLoading: false,
        userContractsByRoleAndID: contracts,
      ),
    );
  }

  Future<void> createContract({
    required String employerWalletID,
    required String employeeWalletID,
    required int collateral,
    required DateTime startFrom,
    required DateTime endFrom,
    required int totalAmount,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await contractUseCase.createContract(
      employerWalletID: employerWalletID,
      employeeWalletID: employeeWalletID,
      collateral: collateral,
      startFrom: startFrom,
      endFrom: endFrom,
      totalAmount: totalAmount,
      role: role,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (contract) => state = state.copyWith(
        isLoading: false,
        userContractsByRoleAndID: [...state.userContractsByRoleAndID, contract],
      ),
    );
  }

  Future<void> getAllEmployees() async {
    state = state.copyWith(isLoading: true);
    final result = await contractUseCase.getAllEmployees();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (employees) => state = state.copyWith(
        isLoading: false,
        allEmployees: employees,
      ),
    );
  }

  Future<void> updateContract({
    required String contractID,
    required ContractEntity contract,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await contractUseCase.updateContract(
      contractID: contractID,
      contract: contract,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (contract) => state = state.copyWith(
        isLoading: false,
        userContractsByRoleAndID: [...state.userContractsByRoleAndID, contract],
      ),
    );
  }

  Future<void> deleteContract({
    required String contractId,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await contractUseCase.deleteContract(
      contractId: contractId,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (isDeleted) {
        if (isDeleted) {
          // Remove the deleted contract from the userContractsByRoleAndID list
          final updatedContracts = state.userContractsByRoleAndID
              .where((contract) => contract.contractId != contractId)
              .toList();

          state = state.copyWith(
            isLoading: false,
            userContractsByRoleAndID: updatedContracts,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Failed to delete contract.',
          );
        }
      },
    );
  }
}
