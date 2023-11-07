import 'package:solarisdemo/redux/auth/auth_reducer.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_reducer.dart';
import 'package:solarisdemo/redux/categories/category_reducer.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_reducer.dart';
import 'package:solarisdemo/redux/device/device_reducer.dart';
import 'package:solarisdemo/redux/notification/notification_reducer.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_reducer.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_reducer.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_reducer.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_reducer.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_reducer.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_reducer.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_reducer.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_reducer.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_reducer.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_reducer.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_reducer.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_reducer.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_reducer.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_reducer.dart';
import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';
import 'package:solarisdemo/redux/transfer/transfer_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState: transactionsReducer(currentState.transactionsState, action),
    creditLineState: creditLineReducer(currentState.creditLineState, action),
    repaymentReminderState: repaymentReminderReducer(currentState.repaymentReminderState, action),
    cardApplicationState: cardApplicationReducer(currentState.cardApplicationState, action),
    billsState: billsReducer(currentState.billsState, action),
    moreCreditState: moreCreditReducer(currentState.moreCreditState, action),
    bankCardState: bankCardReducer(currentState.bankCardState, action),
    bankCardsState: bankCardsReducer(currentState.bankCardsState, action),
    categoriesState: categoriesReducer(currentState.categoriesState, action),
    referenceAccountState: referenceAccountReducer(currentState.referenceAccountState, action),
    personAccountState: personAccountReducer(currentState.personAccountState, action),
    transferState: transferReducer(currentState.transferState, action),
    deviceBindingState: deviceBindingState(currentState.deviceBindingState, action),
    notificationState: notificationReducer(currentState.notificationState, action),
    transactionApprovalState: transactionApprovalReducer(currentState.transactionApprovalState, action),
    accountSummaryState: accountSummaryReducer(currentState.accountSummaryState, action),
    authState: authReducer(currentState.authState, action),
    homePageTransactionsState: homeTransactionsReducer(currentState.homePageTransactionsState, action),
    onboardingSignupState: onboardingSignupReducer(currentState.onboardingSignupState, action),
    onboardingProgressState: onboardingProgressReducer(currentState.onboardingProgressState, action),
    onboardingPersonalDetailsState: onboardingPersonDetailsReducer(currentState.onboardingPersonalDetailsState, action),
    // onboardingFinancialDetailsState:
    //     onboardingFinancialDetailsReducer(currentState.onboardingFinancialDetailsState, action),
    citySuggestionsState: citySuggestionsReducer(currentState.citySuggestionsState, action),
    addressSuggestionsState: addressSuggestionsReducer(currentState.addressSuggestionsState, action),
  );
}
