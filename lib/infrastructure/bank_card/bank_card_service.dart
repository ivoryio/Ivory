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
      final data = await get('/cards/$cardId');

      return GetBankCardSuccessResponse(
        bankCard: _mapBankCard(data),
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
      final data = await get('/account/${user.accountId}/cards');

      return GetBankCardsServiceResponse(
        bankCards: (data as List).map(_mapBankCard).toList(),
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

  Future<BankCardServiceResponse> getEncodedBankCardDetails({
    required String cardId,
    required User user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    this.user = user;

    try {
      final data = await post(
        '/cards/$cardId/details',
        body: reqBody.toJson(),
      );

      return GetEncodedCardDetailsSuccessResponse(
        encodedCardDetails: data['data'],
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> getBankCardDetails({
    required User user,
    required String cardId,
  }) async {
    try {
      final data = await post(
        '/cards/$cardId/details',
      );

      return GetCardDetailsSuccessResponse(
        bankCard: BankCardFetchedDetails(
          cardHolder: data["representation"]["name"] ?? "",
          cardNumber: data["representation"]["cardNumber"] ?? "",
          cardExpiry: data["representation"]["expirationDate"] ?? "",
          cvv: data["representation"]["cvv"] ?? "",
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

  BankCard _mapBankCard(dynamic card) {
    return BankCard(
      id: card["id"],
      type: _mapCardType(card["type"]),
      accountId: card["accountId"],
      status: _mapCardStatus(card["status"]),
      representation: BankCardRepresentation(
        line1: card["representation"]["name"],
        line2: card["representation"]["name"],
        formattedExpirationDate: card["representation"]["expirationDate"],
        maskedPan: card["representation"]["cardNumber"],
      ),
    );
  }

  BankCardType _mapCardType(String? cardType) {
    final cardTypeMap = {
      "VIRTUAL": BankCardType.VIRTUAL,
      "PHYSICAL": BankCardType.PHYSICAL,
    };

    if (cardTypeMap[cardType] == null) {
      throw Exception("card type $cardType not supported");
    }

    return cardTypeMap[cardType]!;
  }

  BankCardStatus _mapCardStatus(String? status) {
    final cardStatusMap = {
      "ACTIVE": BankCardStatus.ACTIVE,
      "INACTIVE": BankCardStatus.INACTIVE,
      "BLOCKED": BankCardStatus.BLOCKED,
      "PROCESSING": BankCardStatus.PROCESSING,
    };

    if (cardStatusMap[status] == null) {
      throw Exception("card status $status not supported");
    }

    return cardStatusMap[status]!;
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

class GetEncodedCardDetailsSuccessResponse extends BankCardServiceResponse {
  final String encodedCardDetails;

  GetEncodedCardDetailsSuccessResponse({required this.encodedCardDetails});

  @override
  List<Object?> get props => [encodedCardDetails];
}

class GetCardDetailsSuccessResponse extends BankCardServiceResponse {
  final BankCardFetchedDetails bankCard;

  GetCardDetailsSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
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
