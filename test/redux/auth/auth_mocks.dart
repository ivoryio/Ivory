
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/device_fingerprint_error_type.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';

import '../bank_card/bank_card_mocks.dart';

class MockUserSession extends Mock implements CognitoUserSession {}

class MockUserAttribute extends Mock implements CognitoUserAttribute {}

class MockCognitoUser extends Mock implements CognitoUser {}

class MockUser extends Mock implements User {}

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

class FakeNotificationService extends PushNotificationService {
  @override
  Future<void> init(Store<AppState> store) {
    return Future.value();
  }

  @override
  Future<void> clearNotification() {
    return Future.value();
  }

  @override
  Future<void> handleSavedNotification() {
    return Future.value();
  }

  @override
  void handleTokenRefresh({User? user}) {
    return;
  }

  @override
  Future<bool> hasPermission() {
    return Future.value(true);
  }
}

