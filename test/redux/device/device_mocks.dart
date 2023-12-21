import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/crypto/jwk.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/utilities/crypto/crypto_key_generator.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

class MockUser extends Mock implements User {
  @override
  String? get personId => 'personId';
}

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

class MockLocalAutentication extends Mock implements LocalAuthentication {
  final mockLocal = MockLocalAutentication();

  Future<bool> authenticateWithBiometrics({required String message}) async {
    return true;
  }
}

final devices = [
  Device(deviceId: 'deviceId', deviceName: 'deviceName'),
  Device(deviceId: 'deviceId2', deviceName: 'deviceName2'),
];

class FakeBiometricsService extends BiometricsService {
  FakeBiometricsService() : super();

  @override
  Future<bool> authenticateWithBiometrics({required String message}) async {
    return true;
  }

  @override
  Future<bool> biometricsAvailable() async {
    return true;
  }
}

class FakeFailingBiometricsService extends BiometricsService {
  FakeFailingBiometricsService() : super();

  @override
  Future<bool> authenticateWithBiometrics({required String message}) async {
    return false;
  }

  @override
  Future<bool> biometricsAvailable() async {
    return false;
  }
}

class FakeDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> createDeviceBinding({
    required User user,
    required CreateDeviceBindingRequest reqBody,
  }) async {
    return const CreateDeviceBindingSuccessResponse(deviceId: 'deviceId', deviceName: 'deviceName');
  }

  @override
  Future<DeviceBindingServiceResponse> getDeviceBinding({
    required User user,
  }) async {
    return GetDeviceBindingSuccessResponse(
      devices: [
        Device(deviceId: 'deviceId', deviceName: 'deviceName'),
        Device(deviceId: 'deviceId2', deviceName: 'deviceName2'),
      ],
    );
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String deviceId,
    required String deviceFingerPrint,
    required String signature,
  }) async {
    return VerifyDeviceBindingSignatureSuccessResponse();
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required CreateRestrictedKeyRequest reqBody,
  }) async {
    return CreateRestrictedKeySuccessResponse();
  }

  @override
  Future<DeviceBindingServiceResponse> deleteDeviceBinding({
    required User user,
    required String deviceId,
  }) async {
    return DeleteDeviceBindingSuccessResponse();
  }
}

class FakeFailingDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> createDeviceBinding({
    required User user,
    required CreateDeviceBindingRequest reqBody,
  }) async {
    return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.deviceBindingFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> getDeviceBinding({
    required User user,
  }) async {
    return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.getDeviceBindingFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String deviceId,
    required String deviceFingerPrint,
    required String signature,
  }) async {
    return const DeviceBindingServiceErrorResponse(
        errorType: DeviceBindingServiceErrorType.verifyDeviceBindingSignatureFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required CreateRestrictedKeyRequest reqBody,
  }) async {
    return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.createRestrictedKeyFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> deleteDeviceBinding({
    required User user,
    required String deviceId,
  }) async {
    return const DeviceBindingServiceErrorResponse(
        errorType: DeviceBindingServiceErrorType.deletingDeviceBindingFailed);
  }
}

class FakeDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId(String personId) async {
    return 'consentId';
  }

  @override
  Future<String?> getDeviceId() async {
    return 'deviceId';
  }

  @override
  Future<void> saveKeyPairIntoCache({
    required DeviceKeyPairs keyPair,
    bool restricted = false,
  }) async {
    return;
  }

  @override
  Future<void> saveDeviceIdIntoCache(String deviceId) async {
    return;
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    return DeviceKeyPairs(publicKey: 'publicKey', privateKey: 'privateKey');
  }

  @override
  Future<int?> getDevicePairingTriedAt() async {
    return DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch;
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    return 'signature';
  }

  @override
  DeviceKeyPairs? generateECKey() {
    return DeviceKeyPairs(publicKey: 'publicKey', privateKey: 'privateKey');
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
  Jwk? convertRSAPublicKeyToJWK({required RSAPublicKey rsaPublicKey}) {
    return Jwk(
      n: 'n',
      e: 'e',
    );
  }

  @override
  Future<void> saveCredentialsInCache(String email, String password) async {
    return;
  }

  @override
  Future<void> saveConsentIdInCache(String consentId, String personId) async {
    return;
  }
}

class FakeFailingDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId(String personId) async {
    return null;
  }

  @override
  Future<String?> getDeviceId() async {
    return null;
  }

  @override
  Future<void> saveKeyPairIntoCache({
    required DeviceKeyPairs keyPair,
    bool restricted = false,
  }) async {
    return;
  }

  @override
  Future<void> saveDeviceIdIntoCache(String deviceId) async {
    return;
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    return null;
  }

  @override
  Future<int?> getDevicePairingTriedAt() async {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    return null;
  }

  @override
  DeviceKeyPairs? generateECKey() {
    return null;
  }

  @override
  RSAKeyPair? generateRSAKey() {
    return null;
  }

  @override
  Jwk? convertRSAPublicKeyToJWK({required RSAPublicKey rsaPublicKey}) {
    return null;
  }

  @override
  Future<void> saveCredentialsInCache(String email, String password) async {
    return;
  }

  @override
  Future<void> saveConsentIdInCache(String consentId, String personId) async {
    return;
  }
}

class FakeDeviceInfoService extends DeviceInfoService {
  @override
  Future<String> getDeviceName() async {
    return 'deviceName';
  }
}

class FakeDeviceFingerprintService extends DeviceFingerprintService {
  @override
  Future<String> getDeviceFingerprint(String? consentId) async {
    return 'deviceFingerprint';
  }
}
