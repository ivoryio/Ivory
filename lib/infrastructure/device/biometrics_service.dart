import 'package:local_auth/local_auth.dart';

class BiometricsService {
  static final LocalAuthentication auth = LocalAuthentication();

  BiometricsService();

  Future<bool> authenticateWithBiometrics({required String message}) async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        // Biometric authentication is not available on the device.
        return false;
      }

      return await auth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

static Future<bool> areBiometricsAvailable() async {
    try {
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }
}
