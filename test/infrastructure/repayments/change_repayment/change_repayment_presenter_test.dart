import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_presenter.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';

void main() {
  final cardApplication = CreditCardApplication(
    id: 'ff46c26e244f482a955ec0bb9a0170d4ccla',
    externalCustomerId: '',
    customerId: '73650ddb23b1187eeddd89698e378c5dcper',
    accountId: '153873e90e47a9de593b8c1e5ff9fbc0cacc',
    accountIban: 'DE03110101014701986781',
    referenceAccountId: 'fb561717c3d740fa84455b69960d32baracc',
    status: 'FINALIZED',
    productType: 'CONSUMER_CREDIT_CARD',
    billingStartDate: DateTime.parse('2023-09-16'),
    billingEndDate: DateTime.parse('2023-10-15'),
  );

  group('CardApplicationPresenter', () {
    test('presents loading view model when state is loading', () {
      // given
      final state = CardApplicationLoadingState();

      // when
      final viewModel = CardApplicationPresenter.presentCardApplication(
        cardApplicationState: state,
      );

      // then
      expect(viewModel, isA<CardApplicationLoadingViewModel>());
    });

    test('presents error view model when state is error', () {
      // given
      final state = CardApplicationErrorState();

      // when
      final viewModel = CardApplicationPresenter.presentCardApplication(
        cardApplicationState: state,
      );

      // then
      expect(viewModel, isA<CardApplicationErrorViewModel>());
    });

    test('presents fetched view model when state is fetched', () {
      // given
      final state = CardApplicationFetchedState(cardApplication);

      // when
      final viewModel = CardApplicationPresenter.presentCardApplication(
        cardApplicationState: state,
      );

      // then
      expect(viewModel, isA<CardApplicationFetchedViewModel>());
      expect((viewModel as CardApplicationFetchedViewModel).cardApplication, cardApplication);
    });

    test('presents updated view model when state is updated', () {
      // given
      final state = CardApplicationUpdatedState(cardApplication);

      // when
      final viewModel = CardApplicationPresenter.presentCardApplication(
        cardApplicationState: state,
      );

      // then
      expect(viewModel, isA<CardApplicationUpdatedViewModel>());
      expect((viewModel as CardApplicationUpdatedViewModel).cardApplication, cardApplication);
    });
  });
}
