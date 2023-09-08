import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_presenter.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';

class MockUser extends Mock implements User {}

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

void main() {
  final user = AuthenticatedUser(
    cognito: MockUser(),
    person: MockPerson(),
    personAccount: MockPersonAccount(),
  );

  const waitlist = true;

  test('When fetching is in progress it should return loading', () {
    // given
    final moreCreditState = MoreCreditLoadingState();
    // when
    final viewModel = MoreCreditPresenter.presentMoreCredit(
      moreCreditState: moreCreditState,
      user: user,
    );
    // then
    expect(viewModel, MoreCreditLoadingViewModel());
  });

  test('When fetching is successful should return waitlist', () {
    // given
    final moreCreditState = MoreCreditFetchedState(waitlist);
    // when
    final viewModel = MoreCreditPresenter.presentMoreCredit(
      moreCreditState: moreCreditState,
      user: user,
    );
    // then
    expect(viewModel, const MoreCreditFetchedViewModel(waitlist: waitlist));
  });

  test('"when fetching is failed should return error', () {
    // given
    final moreCreditState = MoreCreditErrorState();
    // when
    final viewModel = MoreCreditPresenter.presentMoreCredit(
      moreCreditState: moreCreditState,
      user: user,
    );
    // then
    expect(viewModel, MoreCreditErrorViewModel());
  });
}
