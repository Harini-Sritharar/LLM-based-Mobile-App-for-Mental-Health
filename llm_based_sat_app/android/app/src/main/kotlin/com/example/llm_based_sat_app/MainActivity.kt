package com.example.llm_based_sat_app  // Ensure this matches AndroidManifest.xml

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourapp.auth/session"
    private lateinit var sharedPreferences: SharedPreferences

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sharedPreferences = getSharedPreferences("UserSession", Context.MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setLoginStatus" -> {
                    val isLoggedIn = call.argument<Boolean>("isLoggedIn") ?: false
                    sharedPreferences.edit().putBoolean("isLoggedIn", isLoggedIn).apply()
                    result.success(null)
                }
                "getLoginStatus" -> {
                    val isLoggedIn = sharedPreferences.getBoolean("isLoggedIn", false)
                    result.success(isLoggedIn)
                }
                else -> result.notImplemented()
            }
        }
    }
}
