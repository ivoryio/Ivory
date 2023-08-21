import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class BillService extends ApiService {
  BillService({super.user});

  Future<BillServiceResponse> getBills({
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('account/transactions/past_credit_card_bills'); // bills/past_bills

      return GetBillsSuccessResponse(bills: Bill.fromJson(data));
    } catch (e) {
      return BillServiceErrorResponse();
    }
  }

  Future<BillServiceResponse> getBillById({
    required String id,
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('account/transactions/past_credit_card_bills/$id'); // bills/$id

      return GetBillsSuccessResponse(bills: Bill.fromJson(data));
    } catch (e) {
      return BillServiceErrorResponse();
    }
  }
}

abstract class BillServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBillsSuccessResponse extends BillServiceResponse {
  final Bill bills;

  GetBillsSuccessResponse({required this.bills});

  @override
  List<Object?> get props => [bills];
}

class BillServiceErrorResponse extends BillServiceResponse {}
