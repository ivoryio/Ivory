import UIKit
import Flutter
import SeonSDK
import Foundation
import CryptoKit
import CommonCrypto

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
                    let privateKey = args["privateKeyHex"] as? String
              else {
                  result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid method call arguments", details: nil))
                  return
              }

              let signature = self.signMessage(message: message, privateKeyHex: privateKey)
              result(signature)
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

private func signMessage(message: String, privateKeyHex: String) -> String? {
    print("Private Key Hex: \(privateKeyHex)")
    print("Signing message: \(message)")

    // Convert the hexadecimal private key to Data
    guard let privateKeyData = dataFromHexString(privateKeyHex) else {
        print("Error converting private key hex to data")
        return nil
    }

    // Ensure the private key data has the correct length
    if privateKeyData.count != 32 {
        print("Invalid private key length")
        return nil
    }

    // Convert the private key data to a private key instance
    guard let privateKey = try? P256.Signing.PrivateKey(rawRepresentation: privateKeyData) else {
        print("Error creating private key from data")
        return nil
    }

    // Convert the message to data
    let messageData = Data(message.utf8)

    // Calculate the hash of the message using SHA-256
    let hash = SHA256.hash(data: messageData)

    // Sign the hash with the private key
    let signature = try! privateKey.signature(for: hash)

    // Convert the signature to a Data representation
    let signatureData = signature.rawRepresentation

    // Convert the signature data to a hex-encoded string
    let hexEncodedSignature = signatureData.map { String(format: "%02hhx", $0) }.joined()

    return hexEncodedSignature
}


private func dataFromHexString(_ hexString: String) -> Data? {
    var hex = hexString
    // Ensure the hex string has an even number of characters
    if hex.count % 2 != 0 {
        hex = "0" + hex
    }

    var data = Data(capacity: hex.count / 2)

    var index = hex.startIndex
    while index < hex.endIndex {
        let nextIndex = hex.index(index, offsetBy: 2)
        if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
            data.append(byte)
        } else {
            return nil // Invalid character in the hex string
        }
        index = nextIndex
    }

    return data
}

}
