import 'package:mockito/mockito.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/utilities/crypto/crypto_key_generator.dart';

class MockGetCardDetailsRequestBody extends Mock implements GetCardDetailsRequestBody {}

class MockRSAKeyPair extends Mock implements RSAKeyPair {
  @override
  RSAPublicKey get publicKey => MockRSAPublicKey();
}

class MockRSAPublicKey extends Mock implements RSAPublicKey {}

class FakeBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User? user,
  }) async {
    return GetBankCardSuccessResponse(
      bankCard: BankCard(
        id: "inactive-card-id",
        accountId: "62a8f478184ae7cba59c633373c53286cacc",
        status: BankCardStatus.INACTIVE,
        type: BankCardType.VIRTUAL_VISA_CREDIT,
        representation: BankCardRepresentation(
          line1: "INACTIVE JOE",
          line2: "INACTIVE JOE",
          maskedPan: '493441******9641',
          formattedExpirationDate: '06/26',
        ),
      ),
    );
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User? user,
  }) async {
    return ActivateBankCardSuccessResponse(
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
    );
  }

  @override
  Future<BankCardServiceResponse> getCardDetails({
    required String cardId,
    required User? user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    return GetCardDetailsSuccessResponse(
      encodedCardDetails: "encodedCardDetails",
    );
  }

  @override
  Future<BankCardServiceResponse> getLatestPinKey({
    required String cardId,
    required User? user,
  }) async {
    return GetLatestPinKeySuccessResponse(
      jwkJson: const {
        "kid": "84b5eb09-72b4-4bb4-b105-4cfd11573136",
        "kty": "RSA",
        "use": "enc",
        "alg": "RS256",
        "n":
            "0REZBtc6LmFoWgGe5esVU6QmtmSSnzQFNwnaUeMwVf-8OMa3uxZh1z4upxR80SbHhiPcAKcpkU-2GSE9MS7Fr6VG25tO7JsN8kPEZ59RzEiSn_8sd57AHaIPJnBUHfT5a7qgsgsoJNW6XISGaNfA4MiLskbCnQxDMaOEK9E7yYqC-do4arrqPy61l7gyWkG2IyZFWp48wiibmeBlHqBkihstD0mnXKbx--kjNx0xQ2s5gmvhO402-F4Vap1Yc3Ub1enG0H8u8sIIPG8JHIDO3GgX40WZAI3uRURi7346eWWl0RJ7Ai6Fy7sDFXsn6YiS0o9RegRWFufwMJ8TbIlm5w",
        "e": "AQAB"
      },
    );
  }

  @override
  Future<BankCardServiceResponse> changePin({
    required String cardId,
    required User? user,
    required ChangePinRequestBody reqBody,
  }) async {
    return ChangePinSuccessResponse();
  }

  @override
  Future<BankCardServiceResponse> freezeCard({
    required String cardId,
    required User? user,
  }) async {
    return FreezeBankCardSuccessResponse(
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
    );
  }

  @override
  Future<BankCardServiceResponse> unfreezeCard({
    required String cardId,
    required User? user,
  }) async {
    return UnfreezeBankCardSuccessResponse(
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
    );
  }

  @override
  Future<BankCardServiceResponse> createBankCard({
    required CreateBankCardReqBody reqBody,
    required User? user,
  }) async {
    return CreateBankCardSuccessResponse(
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
    );
  }
}

class FakeFailingBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> getCardDetails({
    required String cardId,
    required User? user,
    required GetCardDetailsRequestBody reqBody,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> getLatestPinKey({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> changePin({
    required String cardId,
    required User? user,
    required ChangePinRequestBody reqBody,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> freezeCard({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> unfreezeCard({
    required String cardId,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }

  @override
  Future<BankCardServiceResponse> createBankCard({
    required CreateBankCardReqBody reqBody,
    required User? user,
  }) async {
    return BankCardErrorResponse();
  }
}

class FakeDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId(String personId) async {
    return "consentId";
  }

  @override
  Future<String?> getDeviceId() async {
    return "deviceId";
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    return DeviceKeyPairs(publicKey: "publicKey", privateKey: "privateKey");
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    return "signature";
  }

  @override
  RSAKeyPair? generateRSAKey() {
    return RSAKeyPair(
        publicKey: RSAPublicKey(
          BigInt.zero,
          BigInt.zero,
        ),
        privateKey: RSAPrivateKey(
          BigInt.zero,
          BigInt.zero,
          BigInt.zero,
          BigInt.zero,
        ));
  }

  @override
  Future<String?> encryptPin({
    required String pinToEncrypt,
    required Map<String, dynamic> pinKey,
  }) async {
    return 'encryptedPin';
  }

  @override
  Future<void> saveCredentialsInCache(String email, String password) async {
    return;
  }

  @override
  Future<void> saveConsentIdInCache(String consentId, String personId) async {
    return;
  }

  @override
  Future<BankCardFetchedDetails> decryptCardDetails({
    required String encodedJwe,
    required RSAPrivateKey privateKey,
    required RSAPublicKey publicKey,
  }) async {
    return BankCardFetchedDetails(
      cardHolder: "INACTIVE JOE",
      cardExpiry: '06/26',
      cvv: "000",
      cardNumber: "4934410000009641",
    );
  }
}

class FakeBiometricsService extends BiometricsService {
  FakeBiometricsService() : super();

  @override
  Future<bool> authenticateWithBiometrics({required String message}) async {
    return true;
  }
}

class FakeDeviceFingerprintService extends DeviceFingerprintService {
  @override
  Future<String> getDeviceFingerprint(String? consentId) async {
    return 'deviceFingerprint';
  }
}

class FakeFailingDeviceFingerprintService extends DeviceFingerprintService {
  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    return null;
  }
}
