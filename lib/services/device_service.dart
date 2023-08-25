// ignore_for_file: depend_on_referenced_packages


import 'package:solarisdemo/models/device_binding.dart';
import 'package:solarisdemo/models/device_consent.dart';
import 'package:solarisdemo/utilities/crypto/crypto_message_signer.dart';

import '../infrastructure/device/device_service.dart';
import '../models/device.dart';
import '../models/device_activity.dart';
import '../utilities/crypto/crypto_key_generator.dart';
import 'api_service.dart';

const String _defaultKeyType = 'ecdsa-p256';
const String _defaultChallengeType = 'sms';
const DeviceBindingKeyPurposeType _defaultKeyPurposeType =
    DeviceBindingKeyPurposeType.unrestricted;
SmsChallenge _defaultSmsChallenge = SmsChallenge(appSignature: 'e2e-e2e-e2e');
const DeviceBindingLanguageType _defaultLanguageType =
    DeviceBindingLanguageType.en;


class OldDeviceService extends ApiService {
  OldDeviceService({required super.user});

  Future<CreateDeviceConsentResponse>? createDeviceConsent() async {
    try {
      String path = 'person/device/consent';

      CreateDeviceConsentRequest reqBody = CreateDeviceConsentRequest(
        confirmedAt: DateTime.now().toUtc(),
        eventType: DeviceConsentEventType.APPROVED,
      );

      Map<String, dynamic> req = reqBody.toJson();

      var data = await post(
        path,
        body: req,
      );
      return CreateDeviceConsentResponse.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load device consent");
    }
  }

  Future<dynamic> createDeviceActivity(DeviceActivityType activityType) async {
    try {
      String path = 'person/device/activity';

      String? consentId = await DeviceService.getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      String? deviceFingerprint =
          await DeviceService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null || deviceFingerprint.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      await post(
        path,
        body: CreateDeviceActivityRequest(
          activityType: activityType,
          deviceData: deviceFingerprint,
        ).toJson(),
      );
      return;
    } catch (e) {
      throw Exception("Failed to load device activity");
    }
  }

  Future<CreateDeviceBindingResponse> createDeviceBinding(
      String personId) async {
    try {
      String path = 'person/device/binding';

      String? consentId = await DeviceService.getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();
      final keyPair = keyGenerator.generateECKeyPair();

      await DeviceService.saveKeyPairIntoCache(
        keyPair: keyPair,
      );

      String publicKey = keyPair.publicKey;

      String? deviceData =
          await DeviceService.getDeviceFingerprint(consentId);
      if (deviceData == null || deviceData.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      CreateDeviceBindingRequest reqBody = CreateDeviceBindingRequest(
        personId: personId,
        keyType: _defaultKeyType,
        challengeType: _defaultChallengeType,
        key: publicKey,
        keyPurpose: _defaultKeyPurposeType,
        name: 'Test Device',
        smsChallenge: _defaultSmsChallenge,
        language: _defaultLanguageType,
        deviceData: deviceData,
      );

      var data = await post(
        path,
        body: reqBody.toJson(),
      );
      var response = CreateDeviceBindingResponse.fromJson(data);
      await DeviceService.saveDeviceIdIntoCache(response.id);
      return response;
    } catch (e) {
      throw Exception('Failed to create device binding - $e');
    }
  }

  Future<void> verifyDeviceBindingSignature(String tan) async {
    try {
      String? deviceId = await DeviceService.getDeviceIdFromCache();
      if (deviceId == null) {
        throw Exception('Device Id not found');
      }

      String consentId = await DeviceService.getDeviceConsentId();

      String? privateKey = await DeviceService.getPrivateKeyFromCache();
      if (privateKey == null) {
        throw Exception('Private key not found');
      }
      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      final signature = messageSigner.signMessage(
        message: tan,
        encodedPrivateKey: privateKey,
      );

      String path = 'person/device/verify_signature/$deviceId';

      String? deviceFingerPrint =
          await DeviceService.getDeviceFingerprint(consentId);
      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      await post(
        path,
        body: VerifyDeviceSignatureChallengeRequest(
          deviceData: deviceFingerPrint,
          signature: signature,
        ).toJson(),
      );
    } catch (e) {
      throw Exception('Failed to verify device signature - $e');
    }
  }

  Future<dynamic> createRestrictedKey() async {
    try {
      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();

      String? deviceId = await DeviceService.getDeviceIdFromCache();
      if (deviceId == null) {
        throw Exception('Device Id not found');
      }
      var newKeyPair = keyGenerator.generateECKeyPair();
      String newPublicKey = newKeyPair.publicKey;

      String? oldPrivateKey = await DeviceService.getPrivateKeyFromCache();

      if (oldPrivateKey == null) {
        throw Exception('Public/private key not found');
      }

      final signature = messageSigner.signMessage(
        message: newPublicKey,
        encodedPrivateKey: oldPrivateKey,
      );

      String? consentId = await DeviceService.getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      String? deviceFingerprint =
          await DeviceService.getDeviceFingerprint(consentId);

      CreateRestrictedKeyRequest reqBody = CreateRestrictedKeyRequest(
        deviceId: deviceId,
        deviceData: deviceFingerprint!,
        deviceSignature: DeviceSignature(
          signature: signature,
          signatureKeyPurpose: DeviceBindingKeyPurposeType.unrestricted,
        ),
        key: newPublicKey,
        keyPurpose: DeviceBindingKeyPurposeType.restricted,
        keyType: _defaultKeyType,
      );

      String path = 'person/device/key';

      await post(
        path,
        body: reqBody.toJson(),
      );

      await DeviceService.saveKeyPairIntoCache(
        keyPair: newKeyPair,
        restricted: true,
      );
    } catch (e) {
      throw Exception('Failed to create restricted key - $e');
    }
  }
}
