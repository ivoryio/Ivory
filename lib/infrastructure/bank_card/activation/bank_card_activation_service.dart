import 'package:equatable/equatable.dart';

import '../../../models/bank_card.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class BankCardActivationService extends ApiService {
  BankCardActivationService({super.user});

  Future<BankCardActivationResponse> getBankCardById(
      {required String cardId, User? user}) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('/account/cards/$cardId');

      return GetBankCardActivationSuccessResponse(
        bankCard: BankCard.fromJson(data),
      );
    } catch (e) {
      return BankCardActivationErrorResponse();
    }
  }
}

abstract class BankCardActivationResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBankCardActivationSuccessResponse extends BankCardActivationResponse {
  final BankCard bankCard;

  GetBankCardActivationSuccessResponse({required this.bankCard});

  @override
  List<Object?> get props => [bankCard];
}

class BankCardActivationErrorResponse extends BankCardActivationResponse {}
