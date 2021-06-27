import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen {
  final Size _size;
  Screen(this._size);

  static Screen _screen;
  static void init(BuildContext c) {
    final size = MediaQuery.of(c).size;
    _screen = new Screen(size);
  }

  static double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;

  static int get screenSize {
    int diagonalSize = diagonalInches.floor();
    if (Platform.isIOS) {
      diagonalSize = diagonalInches.floor();
    }
    return diagonalSize.toInt();
  }

  // bool isLandscape() =>
  //     MediaQuery.of(this.c).orientation == Orientation.landscape;
  //PIXELS
  static Size get size => _screen._size;
  static double get width => _screen._size.width;
  static double get height => _screen._size.height;
  static double get diagonal {
    Size s = _screen._size;
    final diag = sqrt((s.width * s.width) + (s.height * s.height));
    debugPrint('screen size: $s, diagonal: ${diag.toString()}');
    return diag;
  }

  //INCHES
  static Size get inches {
    Size pxSize = _screen._size;
    return Size(pxSize.width / _ppi, pxSize.height / _ppi);
  }

  static double get widthInches => inches.width;
  static double get heightInches => inches.height;
  static double get diagonalInches => diagonal / _ppi;
}

class DeviceInfo {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static DeviceInfo _deviceInfo;

  static Future<void> init() async {
    _deviceInfo = new DeviceInfo();
    await _deviceInfo.initPlateformData();
  }

  static String get name {
    return _deviceInfo._deviceData['name'].toString();
  }

  static bool get physicalDevice =>
      _deviceInfo._deviceData['isPhysicalDevice'] ?? false;

  Future<void> initPlateformData() async {
    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        print(_deviceData);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
