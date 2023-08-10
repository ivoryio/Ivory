import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';

import '../../models/authorization_request.dart';
import '../../models/transfer.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class CreditLineService extends ApiService {
  CreditLineService({super.user});

  Future<AuthorizationRequest> createTransfer(Transfer transfer) async {
    try {
      String path = 'transactions';

      var data = await post(path, body: transfer.toJson());

      return AuthorizationRequest.fromJson(data);
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to create transfer");
    }
  }

  Future<CreditLineServiceResponse> getCreditLine({
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('credit_line');

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
