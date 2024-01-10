import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class BankCardService extends ApiService {
  BankCardService({super.user});

  Future<BankCardServiceResponse> createBankCard({
    required CreateBankCardReqBody reqBody,
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await post('/account/cards', body: reqBody.toJson());

      return CreateBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User user,
  }) async {
    this.user = user;

    try {
      // final data = await get('/account/cards/$cardId');

      final data = {
        "customerId": "293216012",
        "id": "792523412",
        "template": "VISA_VIRTUAL",
        "accountId": "792522812",
        "cardRole": "MAIN",
        "status": "CARD_OK",
        "maskedCardNumber": "111111______8139",
        "statusDate": "2024-01-09T13:28:52",
        "embossing": {
          "additionalField1": null,
          "additionalField2": null,
          "additionalField3": null,
          "additionalField4": null,
          "additionalField5": null,
          "companyName": null,
          "externalLayoutCode": null,
          "firstName": "GYOZO",
          "lastName": "SZASZ",
          "manufacturer": null,
          "physical": null
        },
        "productCode": "VISA_VIRTUAL",
        "expiration": {"year": 2028, "month": 1},
        "regionAndEcommBlocking": {
          "ecomm": false,
          "africa": false,
          "asia": false,
          "europe": false,
          "home": false,
          "northAmerica": false,
          "oceania": false,
          "southAmerica": false
        },
        "reason": "Contract renewal",
        "pinStatus": "D",
        "digitalLayoutCode": "default",
        "segment": null,
        "referenceNumber": "1111110999723837",
        "scheduledClosing": null,
        "usageLimits": [
          {
            "code": "WEEKLY",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          },
          {"code": "DAILY", "values": null},
          {
            "code": "24H",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          },
          {
            "code": "MONTHLY",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 10, "sumAmount": 1000},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          }
        ]
      } as dynamic;

      return GetBankCardSuccessResponse(
        bankCard: BankCard(
          accountId: data['accountId'],
          id: data['id'],
          status: BankCardStatus.ACTIVE,
          type: BankCardType.VIRTUAL_VISA_BUSINESS_DEBIT,
          representation: BankCardRepresentation(
            formattedExpirationDate:
                '${data['expiration']['month']} / ${data['expiration']['year'].toString().substring(2)}}',
            line1: '${data['embossing']['firstName']} ${data['embossing']['lastName']}',
            line2: '${data['embossing']['firstName']} ${data['embossing']['lastName']}',
            maskedPan: data['maskedCardNumber'].replaceAll('_', '*'),
          ),
        ),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> getBankCards({
    required User user,
  }) async {
    this.user = user;

    try {
      // final data = await get('/account/cards');

      final data = [
        {
          "customerId": "293216012",
          "id": "792523412",
          "template": "VISA_VIRTUAL",
          "accountId": "792522812",
          "cardRole": "MAIN",
          "status": "CARD_OK",
          "maskedCardNumber": "111111______8139",
          "statusDate": "2024-01-09T13:28:52",
          "embossing": {"companyName": null, "firstName": "GYOZO", "lastName": "SZASZ"},
          "productCode": "VISA_VIRTUAL"
        },
        {
          "customerId": "293216012",
          "id": "792526012",
          "template": "MC_VIRTUAL",
          "accountId": "792522812",
          "cardRole": "SUPPLEMENTARY",
          "status": "CARD_OK",
          "maskedCardNumber": "111111______1731",
          "statusDate": "2024-01-09T13:48:01",
          "embossing": {"companyName": null, "firstName": "GYOZO", "lastName": "SZASZ"},
          "productCode": "MC_VIRTUAL"
        }
      ] as dynamic;

      return GetBankCardsServiceResponse(
        bankCards: (data as List)
            .map(
              (e) => BankCard(
                id: e['id'] as String,
                accountId: e['accountId'] as String,
                status: BankCardStatus.ACTIVE,
                type: BankCardType.VIRTUAL_VISA_BUSINESS_DEBIT,
                representation: BankCardRepresentation(
                  line1: '${e['embossing']['firstName']} ${e['embossing']['lastName']}',
                  line2: '${e['embossing']['firstName']} ${e['embossing']['lastName']}',
                  maskedPan: e['maskedCardNumber'].replaceAll('_', '*'),
                  formattedExpirationDate: '11/24',
                ),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await post('/account/cards/$cardId');

      return ActivateBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> getCardDetails({
    required String cardId,
    required User user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    this.user = user;

    try {
      //Uncomment this after and remove the row below after final implementation
      // final data = await post(
      //   '/account/cards/$cardId/details',
      //   body: reqBody.toJson(),
      // );
      //TODO: Decode the data string and return the card details, for now, we will just return a dummy data

      return GetCardDetailsSuccessResponse(
        cardDetails: BankCardFetchedDetails(
          cardHolder: 'John Doe',
          cardExpiry: '11/24',
          cvv: '8315',
          cardNumber: '4526 1612 3862 1856',
        ),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> getLatestPinKey({
    required String cardId,
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await get('/account/cards/$cardId/pin_keys/latest');

      return GetLatestPinKeySuccessResponse(
        jwkJson: data,
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> changePin({
    required String cardId,
    required User user,
    required ChangePinRequestBody reqBody,
  }) async {
    this.user = user;

    try {
      await post('/account/cards/$cardId/change_card_pin', body: reqBody.toJson());
      return ChangePinSuccessResponse();
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> freezeCard({
    required String cardId,
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await post('/account/cards/$cardId/block');

      return FreezeBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> unfreezeCard({
    required String cardId,
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await post('/account/cards/$cardId/unblock');

      return UnfreezeBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }
}

abstract class BankCardServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  CreateBankCardSuccessResponse({required this.bankCard});
}

class GetBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  GetBankCardSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}

class GetBankCardsServiceResponse extends BankCardServiceResponse {
  final List<BankCard> bankCards;

  GetBankCardsServiceResponse({required this.bankCards});

  @override
  List<Object?> get props => [bankCards];
}

class ActivateBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  ActivateBankCardSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}

class GetCardDetailsSuccessResponse extends BankCardServiceResponse {
  final BankCardFetchedDetails cardDetails;

  GetCardDetailsSuccessResponse({required this.cardDetails});

  @override
  List<Object?> get props => [cardDetails];
}

class GetLatestPinKeySuccessResponse extends BankCardServiceResponse {
  final Map<String, dynamic> jwkJson;

  GetLatestPinKeySuccessResponse({required this.jwkJson});

  @override
  List<Object?> get props => [jwkJson];
}

class ChangePinSuccessResponse extends BankCardServiceResponse {}

class FreezeBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  FreezeBankCardSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}

class UnfreezeBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  UnfreezeBankCardSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}

class BankCardErrorResponse extends BankCardServiceResponse {}
