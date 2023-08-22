import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class BankCardService extends ApiService {
  BankCardService({super.user});

  Future<BankCardServiceResponse> getBankCardById(
      {required String cardId, required User? user}) async {
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

  Future<BankCardServiceResponse> activateBankCard(
      {required String cardId, required User? user}) async {
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

class BankCardErrorResponse extends BankCardServiceResponse {}
