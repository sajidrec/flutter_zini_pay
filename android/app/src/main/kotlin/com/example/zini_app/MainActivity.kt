package com.example.zini_app // Your package name

import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Channel name to communicate with Flutter
    private val CHANNEL =
        "com.example.zini_app/sms" // Keep the channel name consistent with your package

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Setting up the method channel for sending SMS
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")
                    sendSms(phoneNumber, message)
                    result.success("SMS sent")
                }

                else -> {
                    result.notImplemented() // Handle unimplemented methods
                }
            }
        }
    }

    private fun sendSms(phoneNumber: String?, message: String?) {
        // Check if phone number and message are not null before sending
        if (phoneNumber != null && message != null) {
            try {
                val smsManager = SmsManager.getDefault()
                smsManager.sendTextMessage(phoneNumber, null, message, null, null)
            } catch (e: Exception) {
                e.printStackTrace() // Log any errors
            }
        }
    }
}
