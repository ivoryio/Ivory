import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/transfer/transfer_cubit.dart';
import 'package:solarisdemo/models/change_request.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/transfer.dart';
import 'package:solarisdemo/models/authorization_request.dart';
import 'package:solarisdemo/services/backoffice_services.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/services/change_request_service.dart';

class MockTransactionService extends Mock implements TransactionService {
  @override
  Future<AuthorizationRequest> createTransfer(Transfer transfer) async {
    try {
      return super.noSuchMethod(
        Invocation.method(#createTransfer, [transfer]),
        returnValue: Future.value(AuthorizationRequest(
          authorizationRequest: AuthorizationRequestClass(
            id: 'test',
            status: 'test',
            updatedAt: DateTime.parse('2023-05-09T12:00:00.000Z'),
          ),
          confirmUrl: '',
        )),
        returnValueForMissingStub: Future.value(AuthorizationRequest(
          authorizationRequest: AuthorizationRequestClass(
            id: 'test',
            status: 'test',
            updatedAt: DateTime.parse('2023-05-09T12:00:00.000Z'),
          ),
          confirmUrl: '',
        )),
      );
    } catch (e) {
      log('create transfer error $e');
      throw Exception("Failed to create transfer");
    }
  }
}

class MockChangeRequestService extends Mock implements ChangeRequestService {
  @override
  Future<ChangeRequestConfirmed> confirmChangeRequest(
      String changeRequestId, String tan) async {
    try {
      return super.noSuchMethod(
        Invocation.method(#confirmChangeRequest, [changeRequestId, tan]),
        returnValue: Future.value(ChangeRequestConfirmed(
          success: true,
          response: Response(
              id: 'test',
              status: 'test',
              responseCode: 200,
              responseBody: ResponseBody()),
        )),
        returnValueForMissingStub: Future.value(ChangeRequestConfirmed(
          success: true,
          response: Response(
              id: 'test',
              status: 'test',
              responseCode: 200,
              responseBody: ResponseBody()),
        )),
      );
    } catch (e) {
      log('confirm tan error $e');
      throw Exception("Failed to confirm change request");
    }
  }
}

class MockBackOfficeServices extends Mock implements BackOfficeServices {
  @override
  Future<void> processQueuedBooking(String personId) async {
    try {
      return super.noSuchMethod(
        Invocation.method(#processQueuedBooking, [personId]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
    } catch (e) {
      throw Exception("Failed to add transaction");
    }
  }
}

void main() {
  late MockTransactionService mockTransactionService;
  late MockChangeRequestService mockChangeRequestService;
  late MockBackOfficeServices mockBackOfficeServices;
  late TransferCubit cubit;

  setUp(() {
    mockTransactionService = MockTransactionService();
    mockChangeRequestService = MockChangeRequestService();
    mockBackOfficeServices = MockBackOfficeServices();
    cubit = TransferCubit(
      transactionService: mockTransactionService,
      changeRequestService: mockChangeRequestService,
      backOfficeServices: mockBackOfficeServices,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('TransferCubit', () {
    test('initial state is TransferInitialState', () {
      expect(cubit.state, isA<TransferInitialState>());
    });

    test('setInitState updates state to TransferInitialState', () {
      cubit.setInitState();
      expect(cubit.state, isA<TransferInitialState>());
    });

    test('setBasicData updates state to TransferSetAmountState', () {
      cubit.setBasicData(
        iban: 'test_iban',
        name: 'test_name',
        description: 'test_description',
        amount: 10.0,
        savePayee: true,
        personAccount: PersonAccount(iban: 'test_iban'),
      );
      expect(cubit.state, isA<TransferSetAmountState>());
    });

    test('setAmount updates state to TransferConfirmState', () {
      cubit.setBasicData(
        iban: 'test_iban',
        name: 'test_name',
        description: 'test_description',
        amount: 10.0,
        savePayee: true,
      );
      cubit.setAmount(amount: 20.0);
      expect(cubit.state, isA<TransferConfirmState>());
    });

    // test(
    //   'confirmTan updates state to TransferLoadingState then to TransferConfirmedState on success',
    //   () async {
    //     when(mockChangeRequestService.confirmChangeRequest(
    //       'test_id',
    //       'test_tan',
    //     )).thenAnswer((_) async => ChangeRequestConfirmed(
    //           success: true,
    //           response: Response(
    //               id: 'test',
    //               status: 'test',
    //               responseCode: 200,
    //               responseBody: ResponseBody()),
    //         ));

    //     cubit.setBasicData(
    //       iban: 'test_iban',
    //       name: 'test_name',
    //       description: 'test_description',
    //       amount: 10.0,
    //       savePayee: true,
    //       personAccount: PersonAccount(iban: 'test_iban'),
    //     );
    //     expect(cubit.state, isA<TransferSetAmountState>());

    //     cubit.setAmount(amount: 20.0);

    //     expect(cubit.state, isA<TransferConfirmState>());

    //     cubit.confirmTransfer(
    //       iban: 'test_iban',
    //       name: 'test_name',
    //       description: 'test_description',
    //       amount: 10.0,
    //       savePayee: true,
    //     );

    //     expect(cubit.state, isA<TransferLoadingState>());

    //     await Future.delayed(const Duration(seconds: 2));

    //     cubit.confirmTan('test_tan');

    //     expect(cubit.state, isA<TransferLoadingState>());

    //     expectLater(cubit.stream, emits(isA<TransferConfirmedState>()));
    //   },
    // );

    test(
        'confirmTransfer updates state to TransferLoadingState then to TransferConfirmTanState on success',
        () async {
      var mockTransfer = Transfer(
        recipientName: 'test_name',
        recipientIban: 'test_iban',
        reference: 'test_reference',
        description: 'test_description',
        recipientBic: 'test_bic',
        endToEndId: 'test_endToEndId',
        type: TransferType.SEPA_CREDIT_TRANSFER,
        amount: AmountTransfer(value: 10.0, currency: 'EUR'),
      );

      when(mockTransactionService.createTransfer(mockTransfer)).thenAnswer(
        (_) async => AuthorizationRequest(
          authorizationRequest: AuthorizationRequestClass(
            id: 'test',
            status: 'test',
            updatedAt: DateTime.parse(
              '2023-05-09T12:00:00.000Z',
            ),
          ),
          confirmUrl: '',
        ),
      );

      expect(cubit.state, isA<TransferInitialState>());

      cubit.confirmTransfer(
        iban: 'test_iban',
        name: 'test_name',
        description: 'test_description',
        amount: 10.0,
        savePayee: true,
      );

      expect(cubit.state, isA<TransferLoadingState>());
      expectLater(cubit.stream, emits(isA<TransferConfirmTanState>()));
    });
  });
}
