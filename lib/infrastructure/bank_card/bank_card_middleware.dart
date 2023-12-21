import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/crypto/jwe.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';

import '../../../redux/bank_card/bank_card_action.dart';
import '../../redux/auth/auth_state.dart';
import 'bank_card_service.dart';

class BankCardMiddleware extends MiddlewareClass<AppState> {
  final BankCardService _bankCardService;
  final DeviceService _deviceService;
  final DeviceFingerprintService _deviceFingerprintService;
  final BiometricsService _biometricsService;

  BankCardMiddleware(
      this._bankCardService, this._deviceService, this._biometricsService, this._deviceFingerprintService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if(authState is! AuthenticatedState) {
      return;
    }

    if (action is CreateCardCommandAction) {
      store.dispatch(BankCardsLoadingEventAction());
      final response = await _bankCardService.createBankCard(
        user: authState.authenticatedUser.cognito,
        reqBody: CreateBankCardReqBody(
          action.firstName,
          action.lastName,
          action.type,
          action.businessId,
        ),
      );

      if (response is CreateBankCardSuccessResponse) {
        store.dispatch(UpdateBankCardsEventAction(
          bankCards: [],
          updatedCard: response.bankCard,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is GetBankCardCommandAction) {
      if(store.state.bankCardState is BankCardFetchedState) {
        final BankCardFetchedState state = store.state.bankCardState as BankCardFetchedState;
        if((state.bankCard.id == action.cardId) && (action.forceReloadCardData == false)) {
          return;
        }
      }

      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.getBankCardById(
        user: authState.authenticatedUser.cognito,
        cardId: action.cardId,
      );

      if (response is GetBankCardSuccessResponse) {
        store.dispatch(BankCardFetchedEventAction(
          bankCard: response.bankCard,
          user: authState.authenticatedUser,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is GetBankCardsCommandAction) {
      if((store.state.bankCardsState is BankCardsFetchedState) && (action.forceCardsReload == false)) {
        return;
      }
      store.dispatch(BankCardsLoadingEventAction());

      final response = await _bankCardService.getBankCards(
        user: authState.authenticatedUser.cognito,
      );

      if (response is GetBankCardsServiceResponse) {
        store.dispatch(BankCardsFetchedEventAction(
          bankCards: response.bankCards,
        ));
      } else {
        store.dispatch(BankCardsFailedEventAction());
      }
    }

    if (action is BankCardInitiatePinChangeCommandAction) {
      store.dispatch(BankCardLoadingEventAction());

      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == '') {
        store.dispatch(BankCardNoBoundedDevicesEventAction(bankCard: action.bankCard));
        return null;
      }

      store.dispatch(BankCardFetchedEventAction(bankCard: action.bankCard, user: authState.authenticatedUser));
    }

    if (action is BankCardChoosePinCommandAction) {
      store.dispatch(BankCardPinChoosenEventAction(pin: action.pin, user: authState.authenticatedUser, bankcard: action.bankCard));
    }

    if (action is BankCardConfirmPinCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == '') {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }
      final consentId = await _deviceService.getConsentId(authState.authenticatedUser.cognito.personId!);
      final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final getLatestPinKeyResponse = await _bankCardService.getLatestPinKey(
        user: authState.authenticatedUser.cognito,
        cardId: action.bankCard.id,
      );

      if (getLatestPinKeyResponse is BankCardErrorResponse) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final pinToEncrypt = '{"pin": "${action.pin}"}';
      final jwkJson = (getLatestPinKeyResponse as GetLatestPinKeySuccessResponse).jwkJson;

      final encryptedPin = await _deviceService.encryptPin(pinToEncrypt: pinToEncrypt, pinKey: jwkJson);
      if (encryptedPin is! String) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final restrictedKeypair = await _deviceService.getDeviceKeyPairs(restricted: true);
      if (restrictedKeypair == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final restrictedPrivateKey = restrictedKeypair.privateKey;
      final signature = _deviceService.generateSignature(
        privateKey: restrictedPrivateKey,
        stringToSign: encryptedPin,
      );
      if (signature == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      ChangePinRequestBody reqBody = ChangePinRequestBody(
        signature: signature,
        deviceData: deviceFingerprint,
        deviceId: deviceId!,
        encryptedPin: encryptedPin,
        keyId: jwkJson["kid"],
      );

      final changePinResponse = await _bankCardService.changePin(
        user: authState.authenticatedUser.cognito,
        cardId: action.bankCard.id,
        reqBody: reqBody,
      );

      if (changePinResponse is BankCardErrorResponse) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      store.dispatch(BankCardPinConfirmedEventAction(pin: action.pin, user: authState.authenticatedUser, bankcard: action.bankCard));
    }

    if (action is BankCardActivateCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.activateBankCard(
        user: authState.authenticatedUser.cognito,
        cardId: action.cardId,
      );

      if (response is ActivateBankCardSuccessResponse) {
        store.dispatch(BankCardActivatedEventAction(
          bankCard: response.bankCard,
          user: authState.authenticatedUser,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardFetchDetailsCommandAction) {
      store.dispatch(BankCardLoadingEventAction());

      final deviceId = await _deviceService.getDeviceId();
      if (deviceId == '') {
        store.dispatch(BankCardNoBoundedDevicesEventAction(bankCard: action.bankCard));
        return null;
      }

      final isBiometricsAuthenticated = await _biometricsService.authenticateWithBiometrics(
          message: "'Please use biometric authentication to view card details.'");

      if (!isBiometricsAuthenticated) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final rsaKeyPair = _deviceService.generateRSAKey();
      if (rsaKeyPair == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final jwk = _deviceService.convertRSAPublicKeyToJWK(rsaPublicKey: rsaKeyPair.publicKey);
      if (jwk == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      String? consentId = await _deviceService.getConsentId(authState.authenticatedUser.cognito.personId!);

      if (consentId == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      String? deviceFingerPrint = await _deviceFingerprintService.getDeviceFingerprint(consentId);

      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final existingRestrictedKeyPair = await _deviceService.getDeviceKeyPairs(restricted: true);

      if (existingRestrictedKeyPair == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      String alphabeticJWK = jwk.toAlphabeticJson();

      final signature = _deviceService.generateSignature(
          privateKey: existingRestrictedKeyPair.privateKey, stringToSign: alphabeticJWK);

      if (signature == null) {
        store.dispatch(BankCardFailedEventAction());
        return null;
      }

      final reqBody = GetCardDetailsRequestBody(
        deviceData: deviceFingerPrint,
        deviceId: deviceId!,
        signature: signature,
        jwk: jwk,
        jwe: Jwe.defaultValues(),
      );

      final response = await _bankCardService.getCardDetails(
        user: authState.authenticatedUser.cognito,
        cardId: action.bankCard.id,
        reqBody: reqBody,
      );

      if (response is GetCardDetailsSuccessResponse) {
        //TODO: Decode the data string and pass the card details to the event
        store.dispatch(BankCardDetailsFetchedEventAction(
          cardDetails: response.cardDetails,
          bankCard: action.bankCard,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardFreezeCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.freezeCard(
        cardId: action.bankCard.id,
        user: authState.authenticatedUser.cognito,
      );

      if (response is FreezeBankCardSuccessResponse) {
        store.dispatch(BankCardFetchedEventAction(
          bankCard: response.bankCard,
          user: authState.authenticatedUser,
        ));
        store.dispatch(UpdateBankCardsEventAction(
          bankCards: action.bankCards,
          updatedCard: response.bankCard,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardUnfreezeCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.unfreezeCard(
        cardId: action.bankCard.id,
        user: authState.authenticatedUser.cognito,
      );

      if (response is UnfreezeBankCardSuccessResponse) {
        store.dispatch(BankCardFetchedEventAction(
          bankCard: response.bankCard,
          user: authState.authenticatedUser,
        ));
        store.dispatch(UpdateBankCardsEventAction(
          bankCards: action.bankCards,
          updatedCard: response.bankCard,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }
  }
}
