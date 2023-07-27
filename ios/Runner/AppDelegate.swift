import UIKit
import Flutter
import SeonSDK
import Foundation
import CryptoKit

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
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
        
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
private func generateECDSAP256KeyPair() -> [String: String] {
    // Generate the key pair using CryptoKit
    let privateKey = P256.KeyAgreement.PrivateKey()
    let publicKey = privateKey.publicKey

    // Get the raw binary representation of the keys
    let privateKeyData = privateKey.rawRepresentation
    let publicKeyData = publicKey.rawRepresentation

    // Convert the keys to base64 strings(private key) and hex strings (public key)
    let privateKeyHex = uncompressedPrivateKeyToHex(privateKeyData)
    let publicKeyHex = uncompressedPublicKeyToHex(publicKeyData)

    return [
        "publicKey": publicKeyHex,
        "privateKey": privateKeyHex,
    ]
}

// Function to convert the uncompressed public key to hex format
private func uncompressedPublicKeyToHex(_ publicKeyData: Data) -> String {
    // Uncompressed ECDSA public key format is 04 || x || y
    let xCoordinate = publicKeyData[publicKeyData.startIndex..<publicKeyData.startIndex.advanced(by: 32)]
    let yCoordinate = publicKeyData[publicKeyData.startIndex.advanced(by: 32)..<publicKeyData.endIndex]
    
    let uncompressedPublicKey = "04" + xCoordinate.map { String(format: "%02hhx", $0) }.joined()
                                        + yCoordinate.map { String(format: "%02hhx", $0) }.joined()
    
    return uncompressedPublicKey
}

// Function to convert the ECDSA private key to hex format
private func uncompressedPrivateKeyToHex(_ privateKeyData: Data) -> String {
    return privateKeyData.map { String(format: "%02hhx", $0) }.joined()
}
}
