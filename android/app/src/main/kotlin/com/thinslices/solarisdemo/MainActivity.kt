package com.thinslices.solarisdemo

import io.flutter.embedding.android.FlutterActivity
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

class MainActivity: FlutterActivity() {
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
            } else if (call.method == "generateECDSAP256KeyPair") {
                val keyPair = generateECDSAP256KeyPair()
                result.success(keyPair)
            } else if(call.method == "signMessage") {
                val message = call.argument<String>("message")!!
                val privateKey = call.argument<String>("privateKey")!!
                val signature = signMessage(message, privateKey)
                result.success(signature)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun generateECDSAP256KeyPair(): Map<String, String> {
        val keyGen = KeyPairGenerator.getInstance("EC")
        keyGen.initialize(ECGenParameterSpec("secp256r1"))

        val keyPair = keyGen.generateKeyPair()
        val publicKey = keyPair.public as ECPublicKey
        val privateKey = keyPair.private as ECPrivateKey

        val publicKeyHex = "04" + publicKey.w.affineX.toString(16).toUpperCase() + publicKey.w.affineY.toString(16).toUpperCase()
        val privateKeyHex = privateKey.s.toString(16).toUpperCase()

        return mapOf(
            "publicKey" to publicKeyHex,
            "privateKey" to privateKeyHex
        )
    }

    private fun signMessage(message: String, privateKey: String): String? {
        val privateKeyData = Base64.getDecoder().decode(privateKey)
        val keySpec = PKCS8EncodedKeySpec(privateKeyData)

        val keyFactory = KeyFactory.getInstance("EC")
        val privateKey = keyFactory.generatePrivate(keySpec)

        val signature = Signature.getInstance("SHA256withECDSA")
        signature.initSign(privateKey)
        signature.update(message.toByteArray())

        val signatureBytes = signature.sign()
        return Base64.getEncoder().encodeToString(signatureBytes)
    }
}
