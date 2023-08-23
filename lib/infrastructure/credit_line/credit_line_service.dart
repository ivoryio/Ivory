import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';

import '../../models/user.dart';
import '../../services/api_service.dart';

class CreditLineService extends ApiService {
  CreditLineService({super.user});

  Future<CreditLineServiceResponse> getCreditLine({
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('credit_card/repayment_details');

      return GetCreditLineSuccessResponse(creditLine: CreditLine.fromJson(data));
    } catch (e) {
      return CreditLineServiceErrorResponse();
    }
  }
}

abstract class CreditLineServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCreditLineSuccessResponse extends CreditLineServiceResponse {
  final CreditLine creditLine;

  GetCreditLineSuccessResponse({required this.creditLine});

  @override
  List<Object?> get props => [creditLine];
}

class CreditLineServiceErrorResponse extends CreditLineServiceResponse {}
