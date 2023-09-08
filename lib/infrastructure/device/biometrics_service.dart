import 'package:local_auth/local_auth.dart';

class BiometricsService {
  final LocalAuthentication auth;

  BiometricsService({required this.auth});

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
}
