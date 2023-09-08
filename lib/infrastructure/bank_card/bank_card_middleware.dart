import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/redux/app_state.dart';

import '../../../redux/bank_card/bank_card_action.dart';
import '../../models/bank_card.dart';
import 'bank_card_service.dart';

class BankCardMiddleware extends MiddlewareClass<AppState> {
  final BankCardService _bankCardService;
  final DeviceService _deviceService;

  BankCardMiddleware(this._bankCardService, this._deviceService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetBankCardCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.getBankCardById(
        user: action.user.cognito,
        cardId: action.cardId,
      );

      if (response is GetBankCardSuccessResponse) {
        store.dispatch(BankCardFetchedEventAction(
          bankCard: response.bankCard,
          user: action.user,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardChoosePinCommandAction) {
      store.dispatch(BankCardPinChoosenEventAction(pin: action.pin, user: action.user, bankcard: action.bankCard));
    }

    if (action is BankCardActivateCommandAction) {
      store.dispatch(BankCardLoadingEventAction());
      final response = await _bankCardService.activateBankCard(
        user: action.user.cognito,
        cardId: action.cardId,
      );

      if (response is ActivateBankCardSuccessResponse) {
        store.dispatch(BankCardActivatedEventAction(
          bankCard: response.bankCard,
          user: action.user,
        ));
      } else {
        store.dispatch(BankCardFailedEventAction());
      }
    }

    if (action is BankCardFetchDetailsCommandAction) {
      store.dispatch(BankCardLoadingEventAction());

      //UNCOMMENT THIS AFTER THERE IS FINAL SOLUTION FOR VIEW CARD DETAILS
      // final rsaKeyPair = _deviceService.generateRSAKey();
      // if (rsaKeyPair == null) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // final jwk = _deviceService.convertRSAPublicKeyToJWK(rsaPublicKey: rsaKeyPair.publicKey);
      // if (jwk == null) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // final deviceId = await _deviceService.getDeviceId();
      // String? consentId = await _deviceService.getConsentId();

      // if (consentId == null) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // String? deviceFingerPrint = await _deviceService.getDeviceFingerprint(consentId);

      // if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // final existingRestrictedKeyPair = await _deviceService.getDeviceKeyPairs(restricted: true);

      // if (existingRestrictedKeyPair == null) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // String alphabeticJWK = jwk.toAlphabeticJson();

      // final signature = _deviceService.generateSignature(
      //     privateKey: existingRestrictedKeyPair.privateKey, stringToSign: alphabeticJWK);

      // if (signature == null) {
      //   store.dispatch(BankCardFailedEventAction());
      //   return null;
      // }

      // final reqBody = GetCardDetailsRequestBody(
      //   deviceData: deviceFingerPrint,
      //   deviceId: deviceId!,
      //   signature: signature,
      //   jwk: jwk,
      //   jwe: Jwe.defaultValues(),
      // );

      //DELETE THIS AFTER FINAL VIEW CARD DETAILS IMPLEMENTATION
      final reqBody = GetCardDetailsRequestBody(
        deviceData: 'mockDeviceFingerPrint',
        deviceId: 'a1f9e6c1-1045-4d54-8381-ff9dd4142e88',
        signature: 'mockSignature',
        jwk: Jwk(e: 'AQAB', n: 'mockPublicKey'),
        jwe: Jwe.defaultValues(),
      );

      final response = await _bankCardService.getCardDetails(
        user: action.user.cognito,
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
  }
}
