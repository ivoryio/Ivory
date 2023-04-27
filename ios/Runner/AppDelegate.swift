import UIKit
import Flutter
import SeonSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.thinslices.solarisdemo/native"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

      methodChannel.setMethodCallHandler { (call, result) in
          if call.method == "getIosDeviceFingerprint" {
            let consentId = (call.arguments as? [String: Any])?["consentId"] as? String ?? "DefaultConsentId"
            let seonfp = SeonFingerprint()

            seonfp.setLoggingEnabled(true)

            // Set session_id
            seonfp.sessionId = consentId

            // Compute fingerprint
            seonfp.fingerprintBase64 { (seonFingerprint:String?) in
                result(seonFingerprint)
            }
          } else if call.method == "generateIosECDSAP256KeyPair" {
              let keyPair = self.generateECDSAP256KeyPair()
              result(keyPair)
          } else if call.method == "signMessage" {
              guard let args = call.arguments as? [String: Any],
                    let message = args["message"] as? String,
                    let privateKey = args["privateKey"] as? String
              else {
                  result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid method call arguments", details: nil))
                  return
              }

              let signature = self.signMessage(message: message, privateKey: privateKey)
              result(signature)
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
        
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func generateECDSAP256KeyPair() -> [String: String] {
      let attributes: [String: Any] = [
          kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
          kSecAttrKeySizeInBits as String: 256,
          kSecPrivateKeyAttrs as String: [
              kSecAttrIsPermanent as String: false,
          ],
          kSecPublicKeyAttrs as String: [
              kSecAttrIsPermanent as String: false,
          ],
      ]

      var error: Unmanaged<CFError>?
      guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
          print("Error generating key pair: \(error!.takeRetainedValue() as Error)")
          return [:]
      }

      let publicKey = SecKeyCopyPublicKey(privateKey)!

      let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error)! as Data
      let privateKeyData = SecKeyCopyExternalRepresentation(privateKey, &error)! as Data

      return [
          "publicKey": publicKeyData.base64EncodedString(),
          "privateKey": privateKeyData.base64EncodedString(),
      ]
  }

 private func signMessage(message: String, privateKey: String) -> String? {
    guard let privateKeyData = Data(base64Encoded: privateKey) else {
        print("Error decoding private key")
        return nil
    }

    let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateWithData(privateKeyData as CFData, attributes as CFDictionary, &error) else {
        print("Error creating private key from data: \(error!.takeRetainedValue() as Error)")
        return nil
    }

    guard let messageData = message.data(using: .utf8) else {
        print("Error converting message to data")
        return nil
    }

    var errorSigning: Unmanaged<CFError>?
    guard let signature = SecKeyCreateSignature(privateKey, SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256, messageData as CFData, &errorSigning) as Data? else {
        print("Error signing message: \(errorSigning!.takeRetainedValue() as Error)")
        return nil
    }

    return signature.base64EncodedString()
  } 
}