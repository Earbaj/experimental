package com.example.untitled1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "appChanel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()
                    result.success("Battery: $batteryLevel%")
                } else {
                    result.notImplemented()
                }
            }
    }
    private fun getBatteryLevel(): Int {
        val batteryManager =
            getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
