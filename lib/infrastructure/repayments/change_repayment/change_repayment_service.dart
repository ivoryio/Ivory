import 'package:http/http.dart';
import 'package:solarisdemo/services/api_service.dart';
import 'package:solarisdemo/models/user.dart';

class ChangeRepaymentService extends ApiService {
  ChangeRepaymentService({super.user});

  Future<ChangeRepaymentResponse> updateChangeRepayment({
    User? user,
    required double fixedRate,
  }) async {
    if (user != null) {
      this.user = user;
    }

    Uri url = Uri.parse('/credit_card_applications/1');
    Object body = {
      'repayment_options': {
        'minimum_amount': fixedRate,
      },
    };

    try {
      await patch(url, body: body);

      return ChangeRepaymentSuccessResponse();
    } catch (e) {
      return ChangeRepaymentErrorResponse();
    }
  }
}

abstract class ChangeRepaymentResponse {
  @override
  List<Object?> get props => [];
}

class ChangeRepaymentSuccessResponse extends ChangeRepaymentResponse {}

class ChangeRepaymentErrorResponse extends ChangeRepaymentResponse {}
