import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/change_request_service.dart';
import 'package:solarisdemo/services/transaction_service.dart';

import '../../models/authorization_request.dart';
import '../../models/change_request.dart';
import '../../models/transfer.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  TransactionService transactionService;
  ChangeRequestService changeRequestService;

  TransferCubit({
    required this.transactionService,
    required this.changeRequestService,
  }) : super(const TransferInitialState());

  void setInitState({
    String? iban,
    String? name,
    double? amount,
    bool? savePayee,
  }) {
    emit(TransferInitialState(
      iban: iban,
      name: name,
      savePayee: savePayee,
    ));
  }

  void setBasicData({
    String? iban,
    String? name,
    bool? savePayee,
    double? amount,
  }) {
    emit(TransferSetAmountState(
      iban: iban,
      name: name,
      savePayee: savePayee,
      amount: amount,
    ));
  }

  void setAmount({
    double? amount,
  }) {
    emit(TransferConfirmState(
      name: state.name,
      iban: state.iban,
      amount: amount,
      savePayee: state.savePayee,
    ));
  }

  void confirmTransfer({
    String? iban,
    String? name,
    double? amount,
    bool? savePayee,
  }) async {
    try {
      emit(TransferLoadingState(
        iban: iban,
        name: name,
        amount: amount,
        savePayee: savePayee,
      ));

      AuthorizationRequest authorizationRequest =
          await transactionService.createTransfer(Transfer(
        type: TransferType.SEPA_CREDIT_TRANSFER,
        reference: '123456789',
        description: 'Transfer',
        recipientBic: 'TESTBIC',
        endToEndId: '123456789',
        recipientName: name!,
        recipientIban: iban!,
        amount: Amount(value: amount!, currency: 'EUR'),
      ));

      emit(TransferConfirmTanState(
        iban: iban,
        name: name,
        amount: amount,
        savePayee: savePayee,
        changeRequestId: authorizationRequest.authorizationRequest.id,
      ));
    } catch (error) {
      emit(TransferErrorState(message: error.toString()));
    }
  }

  void confirmTan(String tan) async {
    try {
      emit(TransferLoadingState(
        iban: state.iban,
        name: state.name,
        amount: state.amount,
        savePayee: state.savePayee,
        changeRequestId: state.changeRequestId,
      ));
      if (state.changeRequestId == null) {
        throw Exception("Change request id is null");
      }

      await changeRequestService.confirmChangeRequest(
          state.changeRequestId!, tan);

      emit(TransferConfirmedState(
        iban: state.iban,
        name: state.name,
        amount: state.amount,
        savePayee: state.savePayee,
      ));
    } catch (error) {
      emit(TransferErrorState(message: error.toString()));
    }
  }
}
