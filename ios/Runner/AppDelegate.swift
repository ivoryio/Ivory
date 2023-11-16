import UIKit
import Flutter
import SeonSDK
import Foundation
import CryptoKit
import JOSESwift

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
          } else if call.method == "encryptPin" {
              let pinKey = (call.arguments as? [String: Any])? ["pinKey"] as? String ?? ""
              let pinToEncrypt = (call.arguments as? [String: Any])?["pinToEncrypt"] as? String ?? ""
              
              let jwk = try! RSAPublicKey(data: pinKey.data(using: .utf8)!)
              let publicKey: SecKey = try! jwk.converted(to: SecKey.self)
              
              var jweHeader = JWEHeader(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .A256CBCHS512)
              let kid = jwk["kid"]!
              jweHeader.kid = kid
              let encrypter = Encrypter(keyManagementAlgorithm: jweHeader.keyManagementAlgorithm!, contentEncryptionAlgorithm: jweHeader.contentEncryptionAlgorithm!, encryptionKey: publicKey)
              let jwe = try! JWE(header: jweHeader, payload: Payload(pinToEncrypt.data(using: .utf8)!), encrypter: encrypter!)
              let encryptedData = jwe.compactSerializedString
              
              result(encryptedData)
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
        
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}
