import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class BankCardService extends ApiService {
  BankCardService({super.user});

  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('/account/cards/$cardId');

      return GetBankCardSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardErrorResponse();
    }
  }

  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
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
    required User? user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    if (user != null) {
      this.user = user;
    }
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
}

abstract class BankCardServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBankCardSuccessResponse extends BankCardServiceResponse {
  final BankCard bankCard;

  GetBankCardSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
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

class BankCardErrorResponse extends BankCardServiceResponse {}
