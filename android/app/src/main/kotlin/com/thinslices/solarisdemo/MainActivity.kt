package com.thinslices.solarisdemo

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.seon.androidsdk.exception.SeonException
import io.seon.androidsdk.service.SeonBuilder
import android.util.Log
import com.nimbusds.jose.EncryptionMethod
import com.nimbusds.jose.JWEAlgorithm
import com.nimbusds.jose.JWEHeader
import com.nimbusds.jose.JWEObject
import com.nimbusds.jose.Payload
import com.nimbusds.jose.crypto.RSAEncrypter
import com.nimbusds.jose.jwk.JWK
import com.nimbusds.jose.jwk.RSAKey


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
            } else if (call.method == "encryptPin") {
                val pinKeyMap = call.argument("pinKey") as Map<String, *>?
                val pinToEncrypt = call.argument<String>("pinToEncrypt") ?: ""

                try {
                val solarisPublicKey = JWK.parse(pinKeyMap)
                    .toRSAKey()
                    .toRSAPublicKey()

                val jweHeader: JWEHeader = JWEHeader
                    .Builder(JWEAlgorithm.RSA_OAEP_256, EncryptionMethod.A256CBC_HS512)
                    .build()

                val jweObject = JWEObject(
                    jweHeader,
                    Payload(pinToEncrypt)
                )

                jweObject.encrypt(RSAEncrypter(solarisPublicKey))

                val encryptedData = jweObject.serialize()

                result.success(encryptedData)

                } catch (e : Exception) {
                    e.printStackTrace()
                    result.error("500", "jwk error", e.toString())
                }

            } else {
                result.notImplemented()
            }
        }
    }
}
