import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

AppState createAppState({
  TransactionsState? transactionsState,
  CreditLineState? creditLineState,
  RepaymentReminderState? repaymentReminderState,
  BillsState? billsState,
  BankCardState? bankCardState,
  CategoriesState? categoriesState,
  ReferenceAccountState? referenceAccountState,
  PersonAccountState? personAccountState,
}) {
  return AppState(
    bankCardState: bankCardState ?? BankCardInitialState(),
    transactionsState: transactionsState ?? TransactionsInitialState(),
    creditLineState: creditLineState ?? CreditLineInitialState(),
    repaymentReminderState:
        repaymentReminderState ?? RepaymentReminderInitialState(),
    billsState: billsState ?? BillsInitialState(),
    categoriesState: categoriesState ?? CategoriesInitialState(),
    referenceAccountState:
        referenceAccountState ?? ReferenceAccountInitialState(),
    personAccountState: personAccountState ?? PersonAccountInitialState(),
  );
}
