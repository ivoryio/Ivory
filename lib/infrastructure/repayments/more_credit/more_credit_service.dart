import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../../models/user.dart';

class MoreCreditService extends ApiService {
  MoreCreditService({super.user});

  Future<MoreCreditServiceResponse> changeWaitlistStatus({User? user}) async {
    // String path = 'repayment/waitlist';

    if (user != null) {
      this.user = user;
    }

    try {
      // var data = await post(path, body: {isWaitlisted: true}});

      return GetMoreCreditSuccessResponse(waitlist: true);
    } catch (e) {
      return MoreCreditServiceErrorResponse();
    }
  }

  Future<MoreCreditServiceResponse> getWaitlistStatus({User? user}) async {
    // String path = 'repayment/waitlist';

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
