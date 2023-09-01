import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/models/user.dart';

class FakeMoreCreditService extends MoreCreditService {
  @override
  Future<MoreCreditServiceResponse> getWaitlistStatus({User? user}) async {
    return GetMoreCreditSuccessResponse(waitlist: false);
  }
}

class FakeFailingMoreCreditService extends MoreCreditService {
  @override
  Future<MoreCreditServiceResponse> getWaitlistStatus({User? user}) async {
    return MoreCreditServiceErrorResponse();
  }
}
