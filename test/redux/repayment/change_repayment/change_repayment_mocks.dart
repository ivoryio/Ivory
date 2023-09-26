import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';

class FakeCardApplicationService extends CardApplicationService {
  @override
  Future<ChangeRepaymentResponse> updateChangeRepayment({
    User? user,
    double? fixedRate,
    String? id,
  }) async {
    return UpdateCardApplicationSuccessResponse(
      creditCardApplication: CreditCardApplication(
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
        repaymentOptions: RepaymentOptions(
          minimumAmount: ApprovedLimit(
            value: 10000,
            currency: Currency.EUR,
            unit: Unit.CENTS,
          ),
          upcomingType: '',
          minimumPercentage: 0,
          currentType: '',
          upcomingBillingCycle: '',
          currentBillingCycle: '',
          gracePeriodInDays: 15,
          minimumAmountLowerThreshold: ApprovedLimit(
            value: 100,
            currency: Currency.EUR,
            unit: Unit.CENTS,
          ),
          minimumAmountUpperThreshold: ApprovedLimit(
            value: 100000,
            currency: Currency.EUR,
            unit: Unit.CENTS,
          ),
          minimumPercentageLowerThreshold: 0,
          minimumPercentageUpperThreshold: 0,
        ),
      ),
    );
  }

  @override
  Future<ChangeRepaymentResponse> getCardApplication({User? user}) async {
    return GetCardApplicationSuccessResponse(
      creditCardApplication: CreditCardApplication(
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
      ),
    );
  }
}

class FakeFailingCardApplicationService extends CardApplicationService {
  @override
  Future<ChangeRepaymentResponse> updateChangeRepayment({
    User? user,
    double? fixedRate,
    String? id,
  }) async {
    return ChangeRepaymentErrorResponse();
  }

  @override
  Future<ChangeRepaymentResponse> getCardApplication({User? user}) async {
    return ChangeRepaymentErrorResponse();
  }
}
