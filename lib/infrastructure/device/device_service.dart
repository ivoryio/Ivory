import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/services/api_service.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';
import 'package:solarisdemo/utilities/device_info/device_utils.dart';

import '../../models/device.dart';
import '../../models/user.dart';
import '../../utilities/crypto/crypto_key_generator.dart';
import '../../utilities/crypto/crypto_message_signer.dart';


class DeviceBindingService extends ApiService {
  final DeviceInfo deviceInfo;

  DeviceBindingService({User? user})
      : deviceInfo = DeviceInfo.instance,
        super(user: user);


  //Service calls
  Future<DeviceBindingServiceResponse> createDeviceBinding({required User user}) async {
    this.user = user;

    try {
      String consentId = await DeviceUtils.getDeviceConsentId();
      String? deviceData = await DeviceUtils.getDeviceFingerprint(consentId);
      if (deviceData == null || deviceData.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      final keyPair = CryptoKeyGenerator.generateECKeyPair();

      await DeviceUtils.saveKeyPairIntoCache(
        keyPair: keyPair,
      );

      String publicKey = keyPair.publicKey;

      String deviceName = await deviceInfo.getDeviceName();

      CreateDeviceBindingRequest reqBody = CreateDeviceBindingRequest(
        personId: user.personId!,
        key: publicKey,
        name: deviceName,
        deviceData: deviceData,
      );

      var data = await post(
        'person/device/binding',
        body: reqBody.toJson(),
      );
      await DeviceUtils.saveDeviceIdIntoCache(data['id']);

      return CreateDeviceBindingSuccessResponse(
        deviceId: data['id'],
        deviceName: deviceName,
      );
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.deviceBindingFailed);
    }
  }

  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String tan,
    required String deviceId,
  }) async {
    this.user = user;
    try {
      String consentId = await DeviceUtils.getDeviceConsentId();

      String? privateKey = await DeviceUtils.getPrivateKeyFromCache();
      if (privateKey == null) {
        throw Exception('Private key not found');
      }

      final signature = CryptoMessageSigner.signMessage(
        message: tan,
        encodedPrivateKey: privateKey,
      );

      String? deviceFingerPrint = await DeviceUtils.getDeviceFingerprint(consentId);
      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      await post(
        'person/device/verify_signature/$deviceId',
        body: VerifyDeviceSignatureChallengeRequest(
          deviceData: deviceFingerPrint,
          signature: signature,
        ).toJson(),
      );

      return VerifyDeviceBindingSignatureSuccessResponse();
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(
          errorType: DeviceBindingServiceErrorType.verifyDeviceBindingSignatureFailed);
    }
  }

  Future<DeviceBindingServiceResponse> createRestrictedKey({required User user, required String deviceId}) async {
    this.user = user;
    try {
      String consentId = await DeviceUtils.getDeviceConsentId();
      String? deviceFingerprint = await DeviceUtils.getDeviceFingerprint(consentId);

      var newKeyPair = CryptoKeyGenerator.generateECKeyPair();
      String newPublicKey = newKeyPair.publicKey;

      String? oldPrivateKey = await DeviceUtils.getPrivateKeyFromCache();

      if (oldPrivateKey == null) {
        throw Exception('Public/private key not found');
      }

      final signature = CryptoMessageSigner.signMessage(
        message: newPublicKey,
        encodedPrivateKey: oldPrivateKey,
      );

      CreateRestrictedKeyRequest reqBody = CreateRestrictedKeyRequest(
        deviceId: deviceId,
        deviceData: deviceFingerprint!,
        deviceSignature: DeviceSignature(
          signature: signature,
        ),
        key: newPublicKey,
      );

      await post(
        'person/device/key',
        body: reqBody.toJson(),
      );

      await DeviceUtils.saveKeyPairIntoCache(
        keyPair: newKeyPair,
        restricted: true,
      );

      return CreateRestrictedKeySuccessResponse();
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(
          errorType: DeviceBindingServiceErrorType.createRestrictedKeyFailed);
    }
  }

  Future<DeviceBindingServiceResponse> deleteDeviceBinding({required User user, required String deviceId}) async {
    this.user = user;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('device_id');
      prefs.remove('restrictedKeyPair');
      prefs.remove('unrestrictedKeyPair');
      
      await delete(
        'person/device/binding/$deviceId',
      );


      return DeleteDeviceBindingSuccessResponse();
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(
          errorType: DeviceBindingServiceErrorType.deletingDeviceBindingFailed);
    }
  }
}

class BiometricAuthentication {
  final LocalAuthentication auth = LocalAuthentication();
  final String message;

  BiometricAuthentication({required this.message});

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = await auth.canCheckBiometrics;
    return isAvailable;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      bool isAvailable = await _isBiometricAvailable();
      if (!isAvailable) {
        // Biometric authentication is not available on the device.
        return false;
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }
}

abstract class DeviceBindingServiceResponse extends Equatable {
  const DeviceBindingServiceResponse();

  @override
  List<Object> get props => [];
}

class CreateDeviceBindingSuccessResponse extends DeviceBindingServiceResponse {
  final String deviceId;
  final String deviceName;

  const CreateDeviceBindingSuccessResponse({
    required this.deviceId,
    required this.deviceName,
  });

  @override
  List<Object> get props => [deviceId, deviceName];
}

class VerifyDeviceBindingSignatureSuccessResponse extends DeviceBindingServiceResponse {}

class CreateRestrictedKeySuccessResponse extends DeviceBindingServiceResponse {}

class DeleteDeviceBindingSuccessResponse extends DeviceBindingServiceResponse {}

class DeviceBindingServiceErrorResponse extends DeviceBindingServiceResponse {
  final DeviceBindingServiceErrorType errorType;

  const DeviceBindingServiceErrorResponse({
    this.errorType = DeviceBindingServiceErrorType.unknown,
  });

  @override
  List<Object> get props => [];
}
