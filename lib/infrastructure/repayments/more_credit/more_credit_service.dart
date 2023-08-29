import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../../models/user.dart';

class MoreCreditService extends ApiService {
  MoreCreditService({super.user});

  Future<MoreCreditServiceResponse> addToWaitlist({User? user}) async {
    // String path = 'repayment/more_credit/';

    if (user != null) {
      this.user = user;
    }

    try {
      // var data = await post(path);

      return GetMoreCreditSuccessResponse(waitlist: true);
    } catch (e) {
      return MoreCreditServiceErrorResponse();
    }
  }

  Future<MoreCreditServiceResponse> checkWaitlistStatus({User? user}) async {
    // String path = 'repayment/more_credit/waitlist';

    if (user != null) {
      this.user = user;
    }

    try {
      // var data = await get(path);

      return GetMoreCreditSuccessResponse(waitlist: false);
    } catch (e) {
      return MoreCreditServiceErrorResponse();
    }
  }
}

abstract class MoreCreditServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMoreCreditSuccessResponse extends MoreCreditServiceResponse {
  final bool waitlist;

  GetMoreCreditSuccessResponse({required this.waitlist});

  @override
  List<Object?> get props => [waitlist];
}

class MoreCreditServiceErrorResponse extends MoreCreditServiceResponse {}
