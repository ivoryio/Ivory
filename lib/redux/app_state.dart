import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/device/device_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

class AppState extends Equatable {
  final TransactionsState transactionsState;
  final CreditLineState creditLineState;
  final RepaymentReminderState repaymentReminderState;
  final BillsState billsState;
  final MoreCreditState moreCreditState;
  final BankCardState bankCardState;
  final CategoriesState categoriesState;
  final ReferenceAccountState referenceAccountState;
  final PersonAccountState personAccountState;
  final TransferState transferState;
  final DeviceBindingState deviceBindingState;

  const AppState({
    required this.transactionsState,
    required this.creditLineState,
    required this.repaymentReminderState,
    required this.billsState,
    required this.moreCreditState,
    required this.bankCardState,
    required this.categoriesState,
    required this.referenceAccountState,
    required this.personAccountState,
    required this.transferState,
    required this.deviceBindingState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
      creditLineState: CreditLineInitialState(),
      repaymentReminderState: RepaymentReminderInitialState(),
      billsState: BillsInitialState(),
      moreCreditState: MoreCreditInitialState(),
      bankCardState: BankCardInitialState(),
      categoriesState: CategoriesInitialState(),
      referenceAccountState: ReferenceAccountInitialState(),
      personAccountState: PersonAccountInitialState(),
      transferState: TransferInitialState(),
        deviceBindingState: DeviceBindingInitialState()
    );
  }

  @override
  List<Object?> get props => [
        transactionsState,
        creditLineState,
        repaymentReminderState,
        billsState,
        moreCreditState,
        bankCardState,
        categoriesState,
        referenceAccountState,
        personAccountState,
        transferState,
        deviceBindingState,
      ];

  @override
  bool get stringify => true;
}
