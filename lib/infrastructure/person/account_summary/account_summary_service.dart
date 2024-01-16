import 'package:equatable/equatable.dart';
import 'package:solarisdemo/config.dart';

import '../../../models/person_account_summary.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class AccountSummaryService extends ApiService {
  AccountSummaryService({
    super.user,
  });

  Future<AccountSummaryServiceResponse> getPersonAccountSummary({required User user}) async {
    this.user = user;
    try {
      String path =
          ClientConfig.getFeatureFlags().simplifiedLogin ? 'account/v4/${user.accountId}' : 'account/summary';

      // var data = await get(path);
      final data = {
        "available": 29354,
        "balance": -646,
        "currency": "EUR",
        "customerId": "293986012",
        "id": "793440512",
        "name": "gytozo gyozo",
        "number": "111111745036161",
        "parentId": null,
        "status": "ACCOUNT_OK",
        "paymentReference": {"number": "1111117450361619", "type": "MOD10"},
        "template": "CREDIT",
        "segment": null,
        "closureReason": null,
        "address": {
          "address1": "test 12 3",
          "address2": null,
          "address3": null,
          "address4": null,
          "city": "m ciuc",
          "country": "DEU",
          "region": null,
          "zipCode": "562125"
        },
        "creditLimit": 30000,
        "productCode": "CREDIT",
        "eInvoice": {"address": null, "operator": null, "paymentInstruction": null},
        "interestPostingEnabled": null,
        "invoiceDayOfMonth": 1,
        "invoiceDeliveryMethod": "REGULAR_MAIL",
        "minimumToPay": {"amount": 50, "percentage": 20},
        "reason": "Contract renewal",
        "usageLimits": [
          {
            "code": "WEEKLY",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          },
          {
            "code": "DAILY",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          },
          {
            "code": "24H",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          },
          {
            "code": "MONTHLY",
            "values": [
              {"code": "ALL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "ATM", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null},
              {"code": "RETAIL", "reset": null, "singleAmount": null, "count": 9999999, "sumAmount": null}
            ]
          }
        ],
        "paymentTerms": null,
        "InvoicePaymentMethod": null
      } as dynamic;

      final accountSummary = ClientConfig.getFeatureFlags().simplifiedLogin
          ? PersonAccountSummary(
              id: (data['id']).toString(),
              availableBalance: Balance(
                currency: data['currency'],
                value: data['available'],
              ),
              balance: Balance(
                currency: data['currency'],
                value: data['balance'],
              ),
              outstandingAmount: 30000.00,
              creditLimit: data['creditLimit'].toDouble(),
            )
          : PersonAccountSummary.fromJson(data);
      return GetAccountSummarySuccessResponse(accountSummary: accountSummary);
    } catch (e) {
      return AccountSummaryServiceErrorResponse();
    }
  }
}

abstract class AccountSummaryServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAccountSummarySuccessResponse extends AccountSummaryServiceResponse {
  final PersonAccountSummary accountSummary;

  GetAccountSummarySuccessResponse({required this.accountSummary});

  @override
  List<Object?> get props => [accountSummary];
}

class AccountSummaryServiceErrorResponse extends AccountSummaryServiceResponse {}
