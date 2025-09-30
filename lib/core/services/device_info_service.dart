// ignore_for_file: unnecessary_null_comparison

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Simple wrapper around `device_info_plus` to expose a consistent API
/// and make it easier to mock in tests / swap implementation later.
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  DeviceInfoService();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfo.webBrowserInfo;
        return _flattenWebBrowserInfo(info);
      }

      final androidInfo = await _deviceInfo.androidInfo;
      if (androidInfo != null) return _flattenAndroidInfo(androidInfo);

      final iosInfo = await _deviceInfo.iosInfo;
      if (iosInfo != null) return _flattenIosInfo(iosInfo);

      final macInfo = await _deviceInfo.macOsInfo;
      if (macInfo != null) return _flattenMacInfo(macInfo);

      final windowsInfo = await _deviceInfo.windowsInfo;
      if (windowsInfo != null) return _flattenWindowsInfo(windowsInfo);

      final linuxInfo = await _deviceInfo.linuxInfo;
      if (linuxInfo != null) return _flattenLinuxInfo(linuxInfo);
    } catch (_) {
      // ignore and return empty map on failure
    }
    return {};
  }

  Map<String, dynamic> _flattenWebBrowserInfo(WebBrowserInfo info) => {
    'userAgent': info.userAgent,
    'vendor': info.vendor,
    'platform': info.platform,
    'hardwareConcurrency': info.hardwareConcurrency,
  };

  Map<String, dynamic> _flattenAndroidInfo(AndroidDeviceInfo info) => {
    'brand': info.brand,
    'model': info.model,
    'androidId': info.id,
    'version': info.version.sdkInt,
  };

  Map<String, dynamic> _flattenIosInfo(IosDeviceInfo info) => {
    'name': info.name,
    'model': info.utsname.machine,
    'systemVersion': info.systemVersion,
  };

  Map<String, dynamic> _flattenMacInfo(MacOsDeviceInfo info) => {
    'computerName': info.computerName,
    'model': info.model,
    'arch': info.arch,
  };

  Map<String, dynamic> _flattenWindowsInfo(WindowsDeviceInfo info) => {
    'computerName': info.computerName,
    'numberOfCores': info.numberOfCores,
    'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
  };

  Map<String, dynamic> _flattenLinuxInfo(LinuxDeviceInfo info) => {
    'name': info.name,
    'version': info.version,
    'id': info.id,
  };
}
