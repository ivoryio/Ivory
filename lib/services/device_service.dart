// ignore_for_file: depend_on_referenced_packages

import 'package:solarisdemo/models/device_consent.dart';
import '../infrastructure/device/device_service.dart';
import '../models/device.dart';
import '../models/device_activity.dart';
import 'api_service.dart';


const DeviceBindingKeyPurposeType _defaultKeyPurposeType =
    DeviceBindingKeyPurposeType.unrestricted;


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



}
