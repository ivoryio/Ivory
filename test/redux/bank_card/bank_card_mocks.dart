import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/user.dart';

class MockGetCardDetailsRequestBody extends Mock implements GetCardDetailsRequestBody {}

class FakeBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User? user,
  }) async {
    return GetBankCardSuccessResponse(
      bankCard: BankCard(
        id: "inactive-card-id",
        accountId: "62a8f478184ae7cba59c633373c53286cacc",
        status: BankCardStatus.INACTIVE,
        type: BankCardType.VIRTUAL_VISA_CREDIT,
        representation: BankCardRepresentation(
          line1: "INACTIVE JOE",
          line2: "INACTIVE JOE",
          maskedPan: '493441******9641',
          formattedExpirationDate: '06/26',
        ),
      ),
    );
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User? user,
  }) async {
    return ActivateBankCardSuccessResponse(
      bankCard: BankCard(
        id: "inactive-card-id",
        accountId: "62a8f478184ae7cba59c633373c53286cacc",
        status: BankCardStatus.ACTIVE,
        type: BankCardType.VIRTUAL_VISA_CREDIT,
        representation: BankCardRepresentation(
          line1: "INACTIVE JOE",
          line2: "INACTIVE JOE",
          maskedPan: '493441******9641',
          formattedExpirationDate: '06/26',
        ),
      ),
    );
  }
  
  @override
  Future<BankCardServiceResponse> getCardDetails({
    required String cardId,
    required User? user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    return GetCardDetailsSuccessResponse(
      cardDetails: BankCardFetchedDetails(
        cardHolder: 'John Doe',
        cardExpiry: '11/24',
        cvv: '8315',
        cardNumber: '4526 1612 3862 1856',
      ),
    );
  }
}

class FakeFailingBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> getCardDetails({
    required String cardId,
    required User? user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    return GetCardDetailsSuccessResponse(
      cardDetails: BankCardFetchedDetails(
        cardHolder: 'John Doe',
        cardExpiry: '11/24',
        cvv: '8315',
        cardNumber: '4526 1612 3862 1856',
      ),
    );
    return BankCardErrorResponse();
  }
}
