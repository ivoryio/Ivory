import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/person_service.dart';
import '../../models/person_account_summary.dart';

part 'account_summary_cubit_state.dart';

class AccountSummaryCubit extends Cubit<AccountSummaryCubitState> {
  final PersonService personService;

  AccountSummaryCubit({required this.personService})
      : super(const AccountSummaryCubitInitial());

  Future<void> getAccountSummary() async {
    try {
      emit(const AccountSummaryCubitLoading());
      PersonAccountSummary? accountSummary =
          await personService.getPersonAccountSummary();

      if (accountSummary is PersonAccountSummary) {
        emit(AccountSummaryCubitLoaded(accountSummary));
      } else {
        emit(const AccountSummaryCubitInitial());
      }
    } catch (e) {
      emit(const AccountSummaryCubitError());
    }
  }
}
