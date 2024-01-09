import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_user_group.dart';
import 'package:solarisdemo/models/auth/device_fingerprint_error_type.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import '../bank_card/bank_card_mocks.dart';

class FakeCognitoAccessToken extends Fake implements CognitoAccessToken {
  FakeCognitoAccessToken() : super();

  @override
  String? get jwtToken => "jwtToken";
}

class FakeUserSession extends Fake implements CognitoUserSession {
  @override
  bool isValid() {
    return true;
  }

  @override
  CognitoAccessToken getAccessToken() {
    return FakeCognitoAccessToken();
  }
}

class MockUserAttribute extends Mock implements CognitoUserAttribute {}

class FakeCognitoUser extends Fake implements CognitoUser {}

class MockUser extends Mock implements User {
  @override
  CognitoUser get cognitoUser => FakeCognitoUser();

  @override
  CognitoUserSession get session => FakeUserSession();

  @override
  List<CognitoUserAttribute> get attributes => [];

  @override
  String? get personId => 'defaultPersonId';
}

class FakeAuthService extends AuthService {
  @override
  Future<AuthServiceResponse> login(
    String email,
    String password,
  ) async {
    return LoginSuccessResponse(
      user: MockUser(),
    );
  }
}

class FakeAuthServiceWithOnboardingUser extends AuthService {
  @override
  Future<AuthServiceResponse> login(
    String email,
    String password,
  ) async {
    final user = MockUser();
    when(user.userGroup).thenReturn(CognitoUserGroup.registering);

    return LoginSuccessResponse(
      user: user,
    );
  }
}

class FakeFailingAuthService extends AuthService {
  @override
  Future<AuthServiceResponse> login(
    String email,
    String password,
  ) async {
    return AuthServiceErrorResponse(
      errorType: AuthErrorType.invalidCredentials,
    );
  }
}

class FakeDeviceFingerprintService extends DeviceFingerprintService {
  @override
  Future<DeviceFingerprintServiceResponse> createDeviceConsent({
    User? user,
  }) async {
    return CreateDeviceConsentResponse(consentId: "consent-id");
  }

  @override
  Future<DeviceFingerprintServiceResponse> createDeviceActivity({
    User? user,
    required DeviceActivityType activityType,
    required String deviceFingerprint,
  }) async {
    return CreateDeviceActivityResponse();
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    return "device-fingerprint";
  }
}

class FakeFailingFingerprintService extends DeviceFingerprintService {
  @override
  Future<DeviceFingerprintServiceResponse> createDeviceConsent({
    User? user,
  }) async {
    return DeviceFingerprintServiceErrorResponse(errorType: DeviceFingerprintErrorType.unableToCreateActivity);
  }

  @override
  Future<DeviceFingerprintServiceResponse> createDeviceActivity({
    User? user,
    required DeviceActivityType activityType,
    required String deviceFingerprint,
  }) async {
    return DeviceFingerprintServiceErrorResponse(errorType: DeviceFingerprintErrorType.unableToCreateActivity);
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    return null;
  }
}

class FakeDeviceServiceWithNoDeviceId extends FakeDeviceService {
  @override
  Future<String?> getDeviceId() async {
    return '';
  }
}

class FakeFailingBiometricsService extends BiometricsService {
  @override
  Future<bool> authenticateWithBiometrics({required String message}) async {
    return false;
  }
}

class FakeDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> getDeviceBinding({required User user}) async {
    return GetDeviceBindingSuccessResponse(
      devices: [
        Device(
          deviceId: 'deviceId',
          deviceName: 'deviceName',
        ),
        Device(
          deviceId: 'deviceId2',
          deviceName: 'deviceName2',
        ),
      ],
    );
  }
}

class FakeDeviceInfoService extends DeviceInfoService {
  @override
  Future<String> getDeviceName() async {
    return 'deviceName';
  }
}
