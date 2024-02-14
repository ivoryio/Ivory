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
      final data = await get('/account/cards/$cardId');

      return GetBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
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
      final data = await get('/account/cards');

      return GetBankCardsServiceResponse(
        bankCards: (data as List).map((e) => BankCard.fromJson(e)).toList(),
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
      final data = await post(
        '/account/cards/$cardId/details',
        body: reqBody.toJson(),
      );

      return GetCardDetailsSuccessResponse(
        encodedCardDetails: data['data'],
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
  final String encodedCardDetails;

  GetCardDetailsSuccessResponse({required this.encodedCardDetails});

  @override
  List<Object?> get props => [encodedCardDetails];
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
