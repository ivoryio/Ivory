import 'package:solarisdemo/models/user.dart';

import '../../../services/api_service.dart';

class ChangeRepaymentService extends ApiService {
  ChangeRepaymentService({super.user});

  Future<ChangeRepaymentResponse> updateChangeRepayment({
    User? user,
    required double fixedRate,
  }) async {
    if (user != null) {
      this.user = user;
    }

    String url = '/credit_card_applications';
    Map<String, dynamic> body = {
      'repayment_options': {
        'minimum_amount': {'value': fixedRate * 100},
      },
    };

    try {
      await patch(url, body: body);

      return ChangeRepaymentSuccessResponse(fixedRate: fixedRate);
    } catch (e) {
      return ChangeRepaymentErrorResponse();
    }
  }
}

abstract class ChangeRepaymentResponse {
  @override
  List<Object?> get props => [];
}

class ChangeRepaymentSuccessResponse extends ChangeRepaymentResponse {
  final double fixedRate;
  ChangeRepaymentSuccessResponse({required this.fixedRate});

  @override
  List<Object?> get props => [fixedRate];
}

class ChangeRepaymentErrorResponse extends ChangeRepaymentResponse {}
