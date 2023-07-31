import 'package:local_auth/local_auth.dart';

class FaceIdAuthentication {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final String message;

  FaceIdAuthentication({required this.message});

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = await _localAuthentication.canCheckBiometrics;
    return isAvailable;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      bool isAvailable = await _isBiometricAvailable();
      if (!isAvailable) {
        // Biometric authentication is not available on the device.
        return false;
      }

      bool didAuthenticate = await _localAuthentication.authenticate(
          localizedReason: message,
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            sensitiveTransaction: true,
          )
          // biometricOnly: true, // Set to true to use only biometrics (Face ID/Touch ID), not device credentials.
          // stickyAuth: true, // Keep the prompt displayed until the user closes it manually.
          );

      return didAuthenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }
}
