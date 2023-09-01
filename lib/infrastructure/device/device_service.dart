import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../models/bank_card.dart';
import '../../models/device.dart';
import '../../models/user.dart';
import '../../utilities/crypto/crypto_key_generator.dart';
import '../../utilities/crypto/crypto_message_signer.dart';
import '../../utilities/crypto/crypto_utils.dart';

MethodChannel _platform = const MethodChannel('com.thinslices.solarisdemo/native');

class DeviceBindingService extends ApiService {
  DeviceBindingService({super.user});

  //Helpers
  static Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return 'Unknown';
  }

  static Future<String?> getDeviceFingerprint(String consentId) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidDeviceFingerprint(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosDeviceFingerprint(consentId);
    }
    return '';
  }

  static Future<String> getDeviceConsentId() async {
    return await _getDeviceConsentId();
  }

  static Future<void> saveDeviceConsentId(String consentId) async {
    await _setDeviceConsentId(consentId);
  }

  static Future<String?> getPublicKeyFromCache({
    bool restricted = false,
  }) async {
    return await _getPublicKeyFromCache(
      restricted: restricted,
    );
  }

  static Future<String?> getPrivateKeyFromCache({
    bool restricted = false,
  }) async {
    return await _getPrivateKeyFromCache(
      restricted: restricted,
    );
  }

  static Future<void> saveKeyPairIntoCache({
    required CryptoKeyPair keyPair,
    bool restricted = false,
  }) async {
    await _setKeyPairIntoCache(
      keyPair: keyPair,
      restricted: restricted,
    );
  }

  static Future<String> getDeviceIdFromCache() async {
    return await _getDeviceIdFromCache();
  }

  static Future<void> saveDeviceIdIntoCache(String deviceId) async {
    await setDeviceIdIntoCache(deviceId);
  }

  static Future<CacheCredentials?> getCredentialsFromCache() async {
    return await _getCredentialsFromCache();
  }

  static Future<void> saveCredentialsInCache(String email, String password) async {
    await _setCredentialsInCache(email, password);
  }

  static Future<void> setDeviceIdIntoCache(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('device_id', deviceId);
  }

  static Future<String> _getDeviceIdFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    return deviceId ?? '';
  }

  static Future<void> _setCredentialsInCache(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  static Future<CacheCredentials?> _getCredentialsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? deviceId = await _getDeviceIdFromCache();

    return CacheCredentials(
      email: email,
      password: password,
      deviceId: deviceId,
    );
  }

  static Future<String> _getPublicKeyFromCache({
    bool restricted = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? keyPairData = prefs.getString(restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair');
    if (keyPairData != null) {
      Map<String, dynamic> keyPairObject = json.decode(keyPairData);
      return keyPairObject['publicKey'] ?? '';
    }

    return '';
  }

  static Future<String> _getPrivateKeyFromCache({
    bool restricted = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? keyPairData = prefs.getString(restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair');
    if (keyPairData != null) {
      Map<String, dynamic> keyPairObject = json.decode(keyPairData);
      return keyPairObject['privateKey'] ?? '';
    }

    return '';
  }

  static Future<void> _setKeyPairIntoCache({
    required CryptoKeyPair keyPair,
    bool restricted = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> keypair = {
      'publicKey': keyPair.publicKey,
      'privateKey': keyPair.privateKey,
    };

    String keyPairData = json.encode(keypair);

    prefs.setString(
      restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair',
      keyPairData,
    );
  }

  static Future<String>? _getAndroidDeviceFingerprint(String deviceConsentId) async {
    try {
      final result = await _platform.invokeMethod(
        'getDeviceFingerprint',
        {'consentId': deviceConsentId},
      );
      return result;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<String>? _getIosDeviceFingerprint(String deviceConsentId) async {
    try {
      final result = await _platform.invokeMethod(
        'getIosDeviceFingerprint',
        {'consentId': deviceConsentId},
      );
      return result;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<String> _getDeviceConsentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceConsentId = prefs.getString('device_consent_id');
    return deviceConsentId ?? '';
  }

  static Future<void> _setDeviceConsentId(String deviceConsentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_consent_id', deviceConsentId);
  }

  static Future<GetCardDetailsRequestBody> createGetCardDetailsRequestBody() async {
    RSAKeyPair rsaKeyPair = CryptoKeyGenerator().generateRSAKeyPair();
    Jwk jwk = CryptoUtils().convertRSAPublicKeyToJWK(
      rsaPublicKey: rsaKeyPair.publicKey,
    );

    String? deviceId = await DeviceBindingService.getDeviceIdFromCache();
    String? consentId = await DeviceBindingService.getDeviceConsentId();
    String? deviceFingerprint = await DeviceBindingService.getDeviceFingerprint(
      consentId,
    );
    String? privateKey = await DeviceBindingService.getPrivateKeyFromCache(
      restricted: true,
    );
    String alphabeticJWK = jwk.toAlphabeticJson();
    String signature = CryptoMessageSigner().signMessage(
      message: alphabeticJWK,
      encodedPrivateKey: privateKey!,
    );

    return GetCardDetailsRequestBody(
      deviceId: deviceId,
      deviceData: deviceFingerprint!,
      signature: signature,
      jwk: jwk,
      jwe: Jwe.defaultValues(),
    );
  }

  //Service calls
  Future<DeviceBindingServiceResponse> createDeviceBinding({required User user}) async {
    this.user = user;

    try {
      String consentId = await DeviceBindingService.getDeviceConsentId();
      String? deviceData = await DeviceBindingService.getDeviceFingerprint(consentId);
      if (deviceData == null || deviceData.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();
      final keyPair = keyGenerator.generateECKeyPair();

      await DeviceBindingService.saveKeyPairIntoCache(
        keyPair: keyPair,
      );

      String publicKey = keyPair.publicKey;

      String deviceName = await getDeviceName();

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
      await DeviceBindingService.saveDeviceIdIntoCache(data['id']);

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
      String consentId = await DeviceBindingService.getDeviceConsentId();

      String? privateKey = await DeviceBindingService.getPrivateKeyFromCache();
      if (privateKey == null) {
        throw Exception('Private key not found');
      }
      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      final signature = messageSigner.signMessage(
        message: tan,
        encodedPrivateKey: privateKey,
      );

      String? deviceFingerPrint = await DeviceBindingService.getDeviceFingerprint(consentId);
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
      String consentId = await DeviceBindingService.getDeviceConsentId();
      String? deviceFingerprint = await DeviceBindingService.getDeviceFingerprint(consentId);

      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();

      var newKeyPair = keyGenerator.generateECKeyPair();
      String newPublicKey = newKeyPair.publicKey;

      String? oldPrivateKey = await DeviceBindingService.getPrivateKeyFromCache();

      if (oldPrivateKey == null) {
        throw Exception('Public/private key not found');
      }

      final signature = messageSigner.signMessage(
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

      await DeviceBindingService.saveKeyPairIntoCache(
        keyPair: newKeyPair,
        restricted: true,
      );

      return CreateRestrictedKeySuccessResponse();
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(
          errorType: DeviceBindingServiceErrorType.createRestrictedKeyFailed);
    }
  }
}

class CacheCredentials {
  String? email;
  String? password;
  String? deviceId;

  CacheCredentials({
    required this.email,
    required this.password,
    required this.deviceId,
  });
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

class DeviceBindingServiceErrorResponse extends DeviceBindingServiceResponse {
  final DeviceBindingServiceErrorType errorType;

  const DeviceBindingServiceErrorResponse({
    this.errorType = DeviceBindingServiceErrorType.unknown,
  });

  @override
  List<Object> get props => [];
}
