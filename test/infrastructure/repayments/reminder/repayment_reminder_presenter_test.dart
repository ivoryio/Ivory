import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_presenter.dart';
import 'package:solarisdemo/models/credit_line.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';

void main() {
  final reminder1 = RepaymentReminder(
    id: "1",
    description: "description1",
    datetime: DateTime.now(),
  );

  test("When fetching is in progress it should return loading", () {
    // given
    final repaymentReminderState = RepaymentReminderLoadingState();
    final creditLineState = CreditLineLoadingState();

    // when
    final viewModel = RepaymentReminderPresenter.presentRepaymentReminder(
      repaymentReminderState: repaymentReminderState,
      creditLineState: creditLineState,
    );

    // then
    expect(viewModel, isA<RepaymentReminderLoadingViewModel>());
  });

  test("When fetching is successful should return fetched", () {
    // given
    final repaymentReminderState = RepaymentReminderFetchedState([reminder1]);
    final creditLineState = CreditLineFetchedState(
      CreditLine.empty(),
    );

    // when
    final viewModel = RepaymentReminderPresenter.presentRepaymentReminder(
      repaymentReminderState: repaymentReminderState,
      creditLineState: creditLineState,
    );

    // then
    expect(viewModel, isA<RepaymentReminderFetchedViewModel>());
    expect(
      (viewModel as RepaymentReminderFetchedViewModel).repaymentReminders,
      [reminder1],
    );
  });

  test("When fetching is failed should return error", () {
    // given
    final repaymentReminderState = RepaymentReminderErrorState();
    final creditLineState = CreditLineFetchedState(
      CreditLine.empty(),
    );

    // when
    final viewModel = RepaymentReminderPresenter.presentRepaymentReminder(
      repaymentReminderState: repaymentReminderState,
      creditLineState: creditLineState,
    );

    // then
    expect(viewModel, isA<RepaymentReminderErrorViewModel>());
  });
}
