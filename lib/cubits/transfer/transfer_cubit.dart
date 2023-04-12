import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  TransferCubit() : super(const TransferInitialState());

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
    emit(TransferStateSetAmount(
      iban: iban,
      name: name,
      savePayee: savePayee,
      amount: amount,
    ));
  }

  void setAmount({
    double? amount,
  }) {
    emit(TransferStateConfirm(
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
    emit(TransferLoadingState(
      iban: iban,
      name: name,
      amount: amount,
      savePayee: savePayee,
    ));
    await Future.delayed(const Duration(seconds: 1));
    emit(TransferStateConfirmTan(
      iban: iban,
      name: name,
      amount: amount,
      savePayee: savePayee,
    ));
  }

  void confirmTan(String tan) async {
    emit(TransferLoadingState(
      iban: state.iban,
      name: state.name,
      amount: state.amount,
      savePayee: state.savePayee,
    ));

    await Future.delayed(const Duration(seconds: 1));

    emit(TransactionStateConfirmed(
      iban: state.iban,
      name: state.name,
      amount: state.amount,
      savePayee: state.savePayee,
    ));
  }
}
