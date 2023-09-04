import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/change_request/change_request_error_type.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/transactions/upcoming_transaction_model.dart';
import 'package:solarisdemo/models/user.dart';

import '../../setup/create_store.dart';

class FakeTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({
    TransactionListFilter? filter,
    User? user,
  }) async {
    return GetTransactionsSuccessResponse(
      transactions: [
        Transaction(
          id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
          bookingType: "SEPA_CREDIT_TRANSFER",
          amount: AmountValue(currency: "EUR", unit: "cents", value: -100),
          description: "test transfer",
          senderIban: "DE60110101014274796688",
          senderName: "THINSLICES MAIN",
          recipientName: "Ionut",
          recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
        ),
        Transaction(
          id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
          bookingType: "INTERNAL_TRANSFER",
          amount: AmountValue(currency: "EUR", unit: "cents", value: -100),
          description: "Top up from Omega to Alpha",
          senderIban: "DE60110101014274796688",
          senderName: "THINSLICES MAIN",
          recipientName: "Ionut",
          recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
        ),
      ],
    );
  }

  @override
  Future<UpcomingTransactionServiceResponse> getUpcomingTransactions({
    User? user,
  }) async {
    return GetUpcomingTransactionsSuccessResponse(
      upcomingTransactions: [
        UpcomingTransaction(
          statementDate: DateTime.now(),
          dueDate: DateTime.now(),
          outstandingAmount: AmountValue(value: 123.45, unit: "cents", currency: "EUR"),
        ),
        UpcomingTransaction(
          statementDate: DateTime.now(),
          dueDate: DateTime.now(),
          outstandingAmount: AmountValue(value: 496.22, unit: "cents", currency: "EUR"),
        ),
      ],
    );
  }
}

class FakeFailingTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({TransactionListFilter? filter, User? user}) async {
    return TransactionsServiceErrorResponse();
  }
}

class FakeChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> authorizeWithDevice({
    User? user,
    required String changeRequestId,
    required String deviceId,
    required String deviceData,
  }) async {
    return AuthorizeChangeRequestSuccessResponse(
      stringToSign: "stringToSign",
    );
  }

  @override
  Future<ChangeRequestServiceResponse> confirmWithDevice({
    User? user,
    required String changeRequestId,
    required String deviceId,
    required String signature,
    required String deviceData,
  }) async {
    return ConfirmChangeRequestSuccessResponse();
  }
}

class FakeFailingChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> authorizeWithDevice({
    User? user,
    required String changeRequestId,
    required String deviceId,
    required String deviceData,
  }) async {
    return ChangeRequestServiceErrorResponse(errorType: ChangeRequestErrorType.authorizationFailed);
  }

  @override
  Future<ChangeRequestServiceResponse> confirmWithDevice({
    User? user,
    required String changeRequestId,
    required String deviceId,
    required String signature,
    required String deviceData,
  }) async {
    return ChangeRequestServiceErrorResponse(errorType: ChangeRequestErrorType.confirmationFailed);
  }
}

class FakeBiometricsService extends BiometricsService {
  FakeBiometricsService() : super(auth: MockLocalAutentication());

  @override
  Future<bool> authenticateWithBiometrics({required String message}) async {
    return true;
  }
}

class FakeDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId() async {
    return "consentId";
  }

  @override
  Future<String?> getDeviceId() async {
    return "deviceId";
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    return "deviceFingerprint";
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    return DeviceKeyPairs(publicKey: "publicKey", privateKey: "privateKey");
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    return "signature";
  }
}

class FakeFailingDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId() async {
    return null;
  }

  @override
  Future<String?> getDeviceId() async {
    return null;
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    return null;
  }
}
