import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';

import '../../setup/authentication_helper.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'bank_card_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

  group("Fetching bank card", () {
    test("When fetching bank card successfully should update with bank card", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
          authState: authState,
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardFetchedState);

      // when
      store.dispatch(
        GetBankCardCommandAction(
          cardId: "inactive-card-id",
          forceReloadCardData: false,
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardFetchedState>());
    });

    test("When fetching bank card is failing should update with error", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeFailingBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
          authState: authState,
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

      // when
      store.dispatch(
        GetBankCardCommandAction(
          cardId: "",
          forceReloadCardData: false,
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardErrorState>());
    });
  });

  group("Activate bank card", () {
    test("When activating bank card successfully should update with bank card", () async {
      // given
      final store = createTestStore(
        bankCardService: FakeBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
          authState: authState,
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardActivatedState);

      // when
      store.dispatch(
        BankCardActivateCommandAction(
          cardId: "inactive-card-id",
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardActivatedState>());
    });

    test("When activating bank card is failing should update with error", () async {
      // given
      final Map<String, Object> values = <String, Object>{'deviceId': 'test'};
      SharedPreferences.setMockInitialValues(values);

      final store = createTestStore(
        bankCardService: FakeFailingBankCardService(),
        initialState: createAppState(
          bankCardState: BankCardInitialState(),
          authState: authState,
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
      final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

      // when
      store.dispatch(
        BankCardActivateCommandAction(
          cardId: "",
        ),
      );

      // then
      expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
      expect((await appState).bankCardState, isA<BankCardErrorState>());
    });
  });

  group("View card details", () {
    group("encoded card details", () {
      setUp(() async {
        SharedPreferences.setMockInitialValues(
          {
            'consents':
                '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
            'unrestrictedKeyPair':
                '{"publicKey":"0440796c6f7921fb8c4c4604f87c7f93e424eec8d97b82611d211566d7f6c27c7f457d5bff4e44280525d9aa321a9aebf0e886845a98aa5ef91d8ccc92eb370e73","privateKey":"8da5191565a42676508fc1bfa6bd9b8c7790944bf15be915de3c19bc241b64c1"}',
            'restrictedKeyPair':
                '{"publicKey":"047df76da16889ce02ee8ebb19cd02c429fbc04642883fc33d057cbe1c5b30733b3e51d4cb7bda834ff3db8b071c72e18bb96bb5257f93746e0286f04c38bb3b4c","privateKey":"8fd52be93fdfacafcf2fec39ca6483340ead732f6b1480cac58d4fedb2aef0b6"}',
            'device_id': 'a1f9e6c1-1045-4d54-8381-ff9dd4142e88'
          },
        );

        TestWidgetsFlutterBinding.ensureInitialized();
        const MethodChannel channel = MethodChannel('com.thinslices.solarisdemo/native');
        channel.setMockMethodCallHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getDeviceFingerprint') {
            return 'mockDeviceFingerPrint';
          }
          if (methodCall.method == 'encryptPin') {
            return 'mockEncryptedPin';
          }
          return null;
        });
      });
      test("When viewing card details successfully should update with card details", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeBankCardService(),
          deviceFingerprintService: FakeDeviceFingerprintService(),
          deviceService: FakeDeviceService(),
          biometricsService: FakeBiometricsService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardDetailsFetchedState);

        // when
        store.dispatch(
          FetchEncodedBankCardDetailsCommandAction(
            bankCard: BankCard(
              id: "inactive-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "INACTIVE JOE",
                line2: "INACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardDetailsFetchedState>());
      });

      test("When viewing card details is failing should update with error", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeFailingBankCardService(),
          deviceService: FakeDeviceService(),
          deviceFingerprintService: FakeDeviceFingerprintService(),
          biometricsService: FakeBiometricsService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );
        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

        // when
        store.dispatch(
          FetchEncodedBankCardDetailsCommandAction(
            bankCard: BankCard(
              id: "inactive-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "INACTIVE JOE",
                line2: "INACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardErrorState>());
      });
    });

    group("plain text card details", () {
      test("When viewing card details successfully should update with card details", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeBankCardService(),
          deviceService: FakeDeviceService(),
          biometricsService: FakeBiometricsService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardDetailsFetchedState);

        // when
        store.dispatch(
          FetchBankCardDetailsCommandAction(
            bankCard: BankCard(
              id: "inactive-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "INACTIVE JOE",
                line2: "INACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardDetailsFetchedState>());
      });

      test("When viewing card details is failing should update with error", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeFailingBankCardService(),
          deviceService: FakeDeviceService(),
          biometricsService: FakeBiometricsService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );
        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

        // when
        store.dispatch(
          FetchBankCardDetailsCommandAction(
            bankCard: BankCard(
              id: "inactive-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "INACTIVE JOE",
                line2: "INACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardErrorState>());
      });
    });
  });

  group(
    "Change pin",
    () {
      setUp(() async {
        SharedPreferences.setMockInitialValues(
          {
            'consents':
                '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
            'unrestrictedKeyPair':
                '{"publicKey":"0440796c6f7921fb8c4c4604f87c7f93e424eec8d97b82611d211566d7f6c27c7f457d5bff4e44280525d9aa321a9aebf0e886845a98aa5ef91d8ccc92eb370e73","privateKey":"8da5191565a42676508fc1bfa6bd9b8c7790944bf15be915de3c19bc241b64c1"}',
            'restrictedKeyPair':
                '{"publicKey":"047df76da16889ce02ee8ebb19cd02c429fbc04642883fc33d057cbe1c5b30733b3e51d4cb7bda834ff3db8b071c72e18bb96bb5257f93746e0286f04c38bb3b4c","privateKey":"8fd52be93fdfacafcf2fec39ca6483340ead732f6b1480cac58d4fedb2aef0b6"}',
            'device_id': 'a1f9e6c1-1045-4d54-8381-ff9dd4142e88'
          },
        );

        TestWidgetsFlutterBinding.ensureInitialized();
        const MethodChannel channel = MethodChannel('com.thinslices.solarisdemo/native');
        channel.setMockMethodCallHandler((MethodCall methodCall) async {
          if (methodCall.method == 'getDeviceFingerprint') {
            return 'mockDeviceFingerPrint';
          }
          if (methodCall.method == 'encryptPin') {
            return 'mockEncryptedPin';
          }
          return null;
        });
      });
      test(
        "When changing pin successfully should return success response",
        () async {
          //given
          final store = createTestStore(
            bankCardService: FakeBankCardService(),
            deviceService: FakeDeviceService(),
            biometricsService: FakeBiometricsService(),
            deviceFingerprintService: FakeDeviceFingerprintService(),
            initialState: createAppState(
              bankCardState: BankCardInitialState(),
              authState: authState,
            ),
          );
          final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
          final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardPinConfirmedState);

          //when
          store.dispatch(
            BankCardConfirmPinCommandAction(
              bankCard: BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.ACTIVE,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
              pin: '1324',
            ),
          );

          //then
          expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
          expect((await appState).bankCardState, isA<BankCardPinConfirmedState>());
        },
      );

      test(
        "When change pin fails, should return error",
        () async {
          //given
          final store = createTestStore(
            bankCardService: FakeFailingBankCardService(),
            deviceService: FakeDeviceService(),
            biometricsService: FakeBiometricsService(),
            deviceFingerprintService: FakeDeviceFingerprintService(),
            initialState: createAppState(
              bankCardState: BankCardInitialState(),
              authState: authState,
            ),
          );

          final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
          final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

          //when
          store.dispatch(
            BankCardConfirmPinCommandAction(
              bankCard: BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.ACTIVE,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
              pin: '1324',
            ),
          );

          //then
          expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
          expect((await appState).bankCardState, isA<BankCardErrorState>());
        },
      );
    },
  );

  group(
    "Freeze/unfreeze card",
    () {
      test("When freezing card successfully should update with bank card", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeBankCardService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardFetchedState);

        // when
        store.dispatch(
          BankCardFreezeCommandAction(
              bankCard: BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.BLOCKED,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
              bankCards: [
                BankCard(
                  id: "active-card-id",
                  accountId: "62a8f478184ae7cba59c633373c53286cacc",
                  status: BankCardStatus.BLOCKED,
                  type: BankCardType.VIRTUAL_VISA_CREDIT,
                  representation: BankCardRepresentation(
                    line1: "ACTIVE JOE",
                    line2: "ACTIVE JOE",
                    maskedPan: '493441******9641',
                    formattedExpirationDate: '06/26',
                  ),
                ),
              ]),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardFetchedState>());
      });

      test("When freezing card is failing should update with error", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeFailingBankCardService(),
          initialState: createAppState(
            bankCardState: BankCardInitialState(),
            authState: authState,
          ),
        );
        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

        // when
        store.dispatch(
          BankCardFreezeCommandAction(
              bankCard: BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.ACTIVE,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
              bankCards: [
                BankCard(
                  id: "active-card-id",
                  accountId: "62a8f478184ae7cba59c633373c53286cacc",
                  status: BankCardStatus.BLOCKED,
                  type: BankCardType.VIRTUAL_VISA_CREDIT,
                  representation: BankCardRepresentation(
                    line1: "ACTIVE JOE",
                    line2: "ACTIVE JOE",
                    maskedPan: '493441******9641',
                    formattedExpirationDate: '06/26',
                  ),
                ),
              ]),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardErrorState>());
      });

      test("  When unfreezing card successfully should update with bank card", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeBankCardService(),
          initialState: createAppState(
            authState: authState,
            bankCardState: BankCardInitialState(),
            bankCardsState: BankCardsFetchedState(
              [
                BankCard(
                  id: "active-card-id",
                  accountId: "62a8f478184ae7cba59c633373c53286cacc",
                  status: BankCardStatus.ACTIVE,
                  type: BankCardType.VIRTUAL_VISA_CREDIT,
                  representation: BankCardRepresentation(
                    line1: "ACTIVE JOE",
                    line2: "ACTIVE JOE",
                    maskedPan: '493441******9641',
                    formattedExpirationDate: '06/26',
                  ),
                ),
              ],
            ),
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardFetchedState);

        // when
        store.dispatch(
          BankCardUnfreezeCommandAction(
            bankCard: BankCard(
              id: "active-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "ACTIVE JOE",
                line2: "ACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
            bankCards: [
              BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.BLOCKED,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
            ],
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardFetchedState>());
      });

      test("When unfreezing card is failing should update with error", () async {
        // given
        final store = createTestStore(
          bankCardService: FakeFailingBankCardService(),
          initialState: createAppState(
            authState: authState,
            bankCardState: BankCardInitialState(),
            bankCardsState: BankCardsFetchedState(
              [
                BankCard(
                  id: "active-card-id",
                  accountId: "62a8f478184ae7cba59c633373c53286cacc",
                  status: BankCardStatus.ACTIVE,
                  type: BankCardType.VIRTUAL_VISA_CREDIT,
                  representation: BankCardRepresentation(
                    line1: "ACTIVE JOE",
                    line2: "ACTIVE JOE",
                    maskedPan: '493441******9641',
                    formattedExpirationDate: '06/26',
                  ),
                ),
              ],
            ),
          ),
        );
        final loadingState = store.onChange.firstWhere((element) => element.bankCardState is BankCardLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardState is BankCardErrorState);

        // when
        store.dispatch(
          BankCardUnfreezeCommandAction(
            bankCard: BankCard(
              id: "active-card-id",
              accountId: "62a8f478184ae7cba59c633373c53286cacc",
              status: BankCardStatus.ACTIVE,
              type: BankCardType.VIRTUAL_VISA_CREDIT,
              representation: BankCardRepresentation(
                line1: "ACTIVE JOE",
                line2: "ACTIVE JOE",
                maskedPan: '493441******9641',
                formattedExpirationDate: '06/26',
              ),
            ),
            bankCards: [
              BankCard(
                id: "active-card-id",
                accountId: "62a8f478184ae7cba59c633373c53286cacc",
                status: BankCardStatus.BLOCKED,
                type: BankCardType.VIRTUAL_VISA_CREDIT,
                representation: BankCardRepresentation(
                  line1: "ACTIVE JOE",
                  line2: "ACTIVE JOE",
                  maskedPan: '493441******9641',
                  formattedExpirationDate: '06/26',
                ),
              ),
            ],
          ),
        );

        // then
        expect((await loadingState).bankCardState, isA<BankCardLoadingState>());
        expect((await appState).bankCardState, isA<BankCardErrorState>());
      });

      test("When creating a card is succesfull should update with bank card", () async {
        // given
        List<BankCard> bankCards = [];
        final store = createTestStore(
          bankCardService: FakeBankCardService(),
          initialState: createAppState(
            bankCardsState: BankCardsFetchedState(bankCards),
            authState: authState,
          ),
        );

        final loadingState = store.onChange.firstWhere(
          (element) => element.bankCardsState is BankCardsLoadingState,
        );
        final appState = store.onChange.firstWhere(
          (element) => element.bankCardsState is BankCardsFetchedState,
        );

        // when
        store.dispatch(
          CreateCardCommandAction(
            firstName: 'Joe',
            lastName: 'Doe',
            type: BankCardType.VIRTUAL_VISA_CREDIT,
            businessId: 'businessId',
          ),
        );

        // then
        expect((await loadingState).bankCardsState, isA<BankCardsLoadingState>());
        expect((await appState).bankCardsState, isA<BankCardsFetchedState>());
      });

      test("When creating a card is failing should update with error", () async {
        // given
        List<BankCard> bankCards = [];
        final store = createTestStore(
          bankCardService: FakeFailingBankCardService(),
          initialState: createAppState(
            bankCardsState: BankCardsFetchedState(bankCards),
            authState: authState,
          ),
        );
        final loadingState = store.onChange.firstWhere((element) => element.bankCardsState is BankCardsLoadingState);
        final appState = store.onChange.firstWhere((element) => element.bankCardsState is BankCardsErrorState);

        // when
        store.dispatch(
          CreateCardCommandAction(
            firstName: 'Joe',
            lastName: 'Doe',
            type: BankCardType.VIRTUAL_VISA_CREDIT,
            businessId: 'businessId',
          ),
        );

        // then
        expect((await loadingState).bankCardsState, isA<BankCardsLoadingState>());
        expect((await appState).bankCardsState, isA<BankCardsErrorState>());
      });
    },
  );
}
