import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_action.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';

import '../../../cubits/login_cubit_test.dart';
import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import 'reminder_mocks.dart';

void main() {
  group("Fetching repayment reminders", () {
    test("When fetching repayment reminders successfully should update with reminders", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderFetchedState);

      // when
      store.dispatch(
        GetRepaymentRemindersCommandAction(
          user: User(
            session: MockUserSession(),
            attributes: [],
            cognitoUser: MockCognitoUser(),
          ),
        ),
      );

      // then
      expect((await loadingState).repaymentReminderState, isA<RepaymentReminderLoadingState>());
      expect((await appState).repaymentReminderState, isA<RepaymentReminderFetchedState>());
    });

    test("When fetching repayment reminders is failing should update with error", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeFailingRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderErrorState);

      // when
      store.dispatch(
        GetRepaymentRemindersCommandAction(
          user: User(
            session: MockUserSession(),
            attributes: [],
            cognitoUser: MockCognitoUser(),
          ),
        ),
      );

      // then
      expect((await loadingState).repaymentReminderState, isA<RepaymentReminderLoadingState>());
      expect((await appState).repaymentReminderState, isA<RepaymentReminderErrorState>());
    });
  });

  group("Updating repayment reminders", () {
    test("When updating repayment reminders successfully", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderFetchedState(List.empty(growable: true)),
        ),
      );

      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderFetchedState);

      // when
      store.dispatch(
        UpdateRepaymentRemindersCommandAction(
          reminders: [
            RepaymentReminder(id: "2", description: "test", datetime: DateTime.now()),
          ],
          user: User(
            session: MockUserSession(),
            attributes: [],
            cognitoUser: MockCognitoUser(),
          ),
        ),
      );

      // then
      expect((await appState).repaymentReminderState, isA<RepaymentReminderFetchedState>());
    });

    test("When updating repayment reminders is failing ", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeFailingRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderFetchedState(List.empty(growable: true)),
        ),
      );

      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderErrorState);

      // when
      store.dispatch(
        UpdateRepaymentRemindersCommandAction(
          user: User(
            session: MockUserSession(),
            attributes: [],
            cognitoUser: MockCognitoUser(),
          ),
          reminders: [],
        ),
      );

      // then
      expect((await appState).repaymentReminderState, isA<RepaymentReminderErrorState>());
    });
  });

  group("Deleting repayment reminders", () {
    test("When deleting repayment reminders successfully", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderFetchedState(List.empty(growable: true)),
        ),
      );

      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderFetchedState);

      // when
      store.dispatch(
        DeleteRepaymentReminderCommandAction(
          reminder: RepaymentReminder(id: "1", description: "test", datetime: DateTime.now()),
        ),
      );

      // then
      expect((await appState).repaymentReminderState, isA<RepaymentReminderFetchedState>());
    });

    test("When deleting repayment reminders is failing", () async {
      // given
      final store = createTestStore(
        repaymentReminderService: FakeFailingRepaymentReminderService(),
        initialState: createAppState(
          repaymentReminderState: RepaymentReminderFetchedState(List.empty(growable: true)),
        ),
      );

      final appState =
          store.onChange.firstWhere((element) => element.repaymentReminderState is RepaymentReminderErrorState);

      // when
      store.dispatch(
        DeleteRepaymentReminderCommandAction(
          reminder: RepaymentReminder(id: "1", description: "test", datetime: DateTime.now()),
        ),
      );

      // then
      expect((await appState).repaymentReminderState, isA<RepaymentReminderErrorState>());
    });
  });
}
