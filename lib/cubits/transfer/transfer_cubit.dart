import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/utilities/constants.dart';
import 'package:uuid/uuid.dart';

import '../../models/transfer.dart';
import '../../models/person_account.dart';
import '../../infrastructure/transactions/transaction_service.dart';
import '../../services/backoffice_services.dart';
import '../../models/authorization_request.dart';
import '../../services/change_request_service.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  TransactionService transactionService;
  ChangeRequestService changeRequestService;
  BackOfficeServices backOfficeServices;

  TransferCubit({
    required this.transactionService,
    required this.changeRequestService,
    required this.backOfficeServices,
  }) : super(const TransferInitialState());

  void setInitState({
    String? iban,
    String? name,
    String? description,
    double? amount,
    bool? savePayee,
    PersonAccount? personAccount,
  }) {
    emit(TransferInitialState(
      iban: iban,
      name: name,
      description: description,
      savePayee: savePayee,
    ));
  }

  void setBasicData({
    String? iban,
    String? name,
    String? description,
    double? amount,
    bool? savePayee,
    PersonAccount? personAccount,
  }) {
    emit(TransferSetAmountState(
      iban: iban,
      name: name,
      description: description,
      amount: amount,
      savePayee: savePayee,
    ));
  }

  void setAmount({
    double? amount,
  }) {
    emit(TransferConfirmState(
      amount: amount,
      name: state.name,
      iban: state.iban,
      description: state.description,
      savePayee: state.savePayee,
    ));
  }

  void confirmTransfer({
    required String iban,
    required String name,
    required String description,
    required double amount,
    required bool savePayee,
  }) async {
    try {
      emit(TransferLoadingState(
        iban: iban,
        name: name,
        description: description,
        amount: amount,
        savePayee: savePayee,
      ));

      AuthorizationRequest authorizationRequest =
          await transactionService.createTransfer(Transfer(
        recipientName: name,
        recipientIban: iban.replaceAll(emptySpaceString, emptyStringValue),
        reference: const Uuid().v4(),
        description: description,
        recipientBic: 'SOBKDEB2XXX',
        endToEndId: '',
        type: TransferType.SEPA_CREDIT_TRANSFER,
        amount: AmountTransfer(value: amount, currency: 'EUR'),
      ));

      await Future.delayed(const Duration(seconds: 1));

      emit(TransferConfirmTanState(
        iban: iban,
        name: name,
        description: description,
        token: '212212',
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
        description: state.description,
        token: state.token,
        amount: state.amount,
        savePayee: state.savePayee,
        changeRequestId: state.changeRequestId,
      ));
      if (state.changeRequestId == null) {
        throw Exception("Change request id is null");
      }
      await changeRequestService.confirmChangeRequest(
          state.changeRequestId!, state.token!);

      emit(TransferConfirmedState(
        iban: state.iban,
        name: state.name,
        description: state.description,
        amount: state.amount,
        savePayee: state.savePayee,
      ));
    } catch (error) {
      emit(TransferErrorState(message: error.toString()));
    }
  }
}
