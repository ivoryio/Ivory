import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../../models/user.dart';

class MoreCreditService extends ApiService {
  MoreCreditService({super.user});

  Future<MoreCreditServiceResponse> changeWaitlistStatus({User? user}) async {
    String path = '/repayment/waitlist';

    if (user != null) {
      this.user = user;
    }

    try {
      bool waitlist = await post(path);

      return GetMoreCreditSuccessResponse(waitlist: waitlist);
    } catch (e) {
      return MoreCreditServiceErrorResponse();
    }
  }

  Future<MoreCreditServiceResponse> getWaitlistStatus({User? user}) async {
    String path = '/repayment/waitlist';

    if (user != null) {
      this.user = user;
    }

    try {
      bool waitlist = await get(path);

      return GetMoreCreditSuccessResponse(waitlist: waitlist);
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
