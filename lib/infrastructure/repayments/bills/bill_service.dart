import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class BillService extends ApiService {
  BillService({super.user});

  Future<BillServiceResponse> getBills({
    required User user,
  }) async {
    this.user = user;

    try {
      final data = await get('bills/past_bills');
      final bills = (data as List).map((e) => Bill.fromJson(e)).toList();

      return GetBillsSuccessResponse(bills: bills);
    } catch (e) {
      return BillServiceErrorResponse();
    }
  }

  Future<BillServiceResponse> getBillById({required String id, required User user}) async {
    this.user = user;

    try {
      final data = await get('bills/$id');

      return GetBillByIdSuccessResponse(bill: Bill.fromJson(data));
    } catch (e) {
      return BillServiceErrorResponse();
    }
  }

  Future<Uint8List?> downloadBillAsPdf({
    required String postboxItemId,
  }) async {
    try {
      final data = await downloadPdf('postbox_items/$postboxItemId');

      return data;
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List> downloadPdf(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    try {
      String? accessToken = await getAccessToken();

      final response = await http.get(
        ApiService.url(path, queryParameters: queryParameters),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode != 200) {
        throw Exception("GET request response code: ${response.statusCode}");
      }

      return response.bodyBytes;
    } catch (e) {
      throw Exception("Could not get data");
    }
  }
}

abstract class BillServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBillsSuccessResponse extends BillServiceResponse {
  final List<Bill> bills;

  GetBillsSuccessResponse({required this.bills});

  @override
  List<Object?> get props => [bills];
}

class GetBillByIdSuccessResponse extends BillServiceResponse {
  final Bill bill;

  GetBillByIdSuccessResponse({required this.bill});

  @override
  List<Object?> get props => [bill];
}

class BillServiceErrorResponse extends BillServiceResponse {}
