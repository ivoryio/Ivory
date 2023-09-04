import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';

class MockUser extends Mock implements User {}

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

class FakeDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> createDeviceBinding({required User user}) async {
    return const CreateDeviceBindingSuccessResponse(deviceId: 'deviceId', deviceName: 'deviceName');
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String tan,
    required String deviceId,
  }) async {
    return VerifyDeviceBindingSignatureSuccessResponse();
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required String deviceId,
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
  Future<DeviceBindingServiceResponse> createDeviceBinding({required User user}) async {
    return const DeviceBindingServiceErrorResponse(errorType: DeviceBindingServiceErrorType.deviceBindingFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature({
    required User user,
    required String tan,
    required String deviceId,
  }) async {
    return const DeviceBindingServiceErrorResponse(
        errorType: DeviceBindingServiceErrorType.verifyDeviceBindingSignatureFailed);
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required String deviceId,
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
