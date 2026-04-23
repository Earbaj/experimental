import 'package:flutter/services.dart';

class NativeService {
  static const platform = MethodChannel("appChanel");
  static Future<String> getBatteryPercentage() async {
    try{
      final result = await platform.invokeMethod('getBatteryLevel');
      return result;
    }catch (e) {
      return "Error: $e";
    }
  }
}