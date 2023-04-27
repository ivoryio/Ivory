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
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
