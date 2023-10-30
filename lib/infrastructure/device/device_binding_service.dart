import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../../models/device.dart';
import '../../models/user.dart';

class DeviceBindingService extends ApiService {

  DeviceBindingService({super.user});

  Future<DeviceBindingServiceResponse> createDeviceBinding({
    required User user,
    required CreateDeviceBindingRequest reqBody,
  }) async {
    this.user = user;

    try {
      var data = await post(
        'person/device/binding',
        body: reqBody.toJson(),
      );

      return CreateDeviceBindingSuccessResponse(
        deviceId: data['id'],
        deviceName: reqBody.name,
      );
    } catch (e) {
      return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.deviceBindingFailed);
    }
  }

  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String deviceId,
    required String deviceFingerPrint,
    required String signature
  }) async {
    this.user = user;

    try {
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

  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required CreateRestrictedKeyRequest reqBody,
  }) async {
    this.user = user;
    try {
      await post(
        'person/device/key',
        body: reqBody.toJson(),
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
