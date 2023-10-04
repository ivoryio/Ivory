import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';

import '../../../services/api_service.dart';

class CardApplicationService extends ApiService {
  CardApplicationService({super.user});

  Future<ChangeRepaymentResponse> updateChangeRepayment({
    User? user,
    required double fixedRate,
    required String id,
  }) async {
    if (user != null) {
      this.user = user;
    }

    String url = '/credit_card_applications/$id';
    Map<String, dynamic> body = {
      'repayment_options': {
        'minimum_amount': {'value': fixedRate * 100},
      },
    };

    try {
      final data = await patch(url, body: body);

      return UpdateCardApplicationSuccessResponse(creditCardApplication: CreditCardApplication.fromJson(data));
    } catch (e) {
      return ChangeRepaymentErrorResponse();
    }
  }

  Future<ChangeRepaymentResponse> getCardApplication({User? user}) async {
    if (user != null) {
      this.user = user;
    }

    String url = '/credit_card_applications';

    try {
      final data = await get(url);

      return GetCardApplicationSuccessResponse(creditCardApplication: CreditCardApplication.fromJson(data));
    } catch (e) {
      return ChangeRepaymentErrorResponse();
    }
  }
}

abstract class ChangeRepaymentResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateCardApplicationSuccessResponse extends ChangeRepaymentResponse {
  final CreditCardApplication creditCardApplication;
  UpdateCardApplicationSuccessResponse({required this.creditCardApplication});

  @override
  List<Object?> get props => [creditCardApplication];
}

class GetCardApplicationSuccessResponse extends ChangeRepaymentResponse {
  final CreditCardApplication creditCardApplication;
  GetCardApplicationSuccessResponse({required this.creditCardApplication});

  @override
  List<Object?> get props => [creditCardApplication];
}

class ChangeRepaymentErrorResponse extends ChangeRepaymentResponse {}
