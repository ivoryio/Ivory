package com.thinslices.solarisdemo

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.seon.androidsdk.exception.SeonException
import io.seon.androidsdk.service.SeonBuilder
import java.security.KeyPairGenerator
import java.security.spec.ECGenParameterSpec
import java.util.Base64
import java.security.Signature
import java.security.spec.PKCS8EncodedKeySpec
import java.security.KeyFactory
import android.util.Log
import java.security.interfaces.ECPublicKey
import java.security.interfaces.ECPrivateKey

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.thinslices.solarisdemo/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceFingerprint") {
                val deviceConsentId = call.argument<String>("consentId") ?: ""
                val seon = SeonBuilder()
                    .withContext(applicationContext)
                    .withSessionId(deviceConsentId)
                    .build()

                seon.setLoggingEnabled(true)
                var deviceData: String? = "";
                try {
                    seon.getFingerprintBase64 { fingerprint: String? ->
                        //set seonFingerprint as the value for the session
                        //property of your Fraud API request.
                        deviceData = fingerprint;
                        result.success(deviceData)
                    }
                } catch (e : SeonException){
                    e.printStackTrace()
                    result.error("500", "Fingeprint error", e.toString())
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
