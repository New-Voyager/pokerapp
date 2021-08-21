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

class CardConvUtils {
  static List<String> cardNamesInSequence = [
    '2s',
    '2h',
    '2d',
    '2c',
    '3s',
    '3h',
    '3d',
    '3c',
    '4c',
    '4s',
    '4h',
    '4d',
    '5h',
    '5d',
    '5c',
    '5s',
    '6s',
    '6h',
    '6d',
    '6c',
    '7s',
    '7h',
    '7d',
    '7c',
    '8s',
    '8h',
    '8d',
    '8c',
    '9s',
    '9h',
    '9d',
    '9c',
    'Th',
    'Td',
    'Tc',
    'Ts',
    'Jc',
    'Js',
    'Jh',
    'Jd',
    'Qs',
    'Qh',
    'Qd',
    'Qc',
    'Ks',
    'Kh',
    'Kd',
    'Kc',
    'Ac',
    'As',
    'Ah',
    'Ad'
  ];

  static Map<int, String> cardNumbers = {
    1: '2s',
    2: '2h',
    4: '2d',
    8: '2c',
    17: '3s',
    18: '3h',
    20: '3d',
    24: '3c',
    40: '4c',
    33: '4s',
    34: '4h',
    36: '4d',
    50: '5h',
    52: '5d',
    56: '5c',
    49: '5s',
    65: '6s',
    66: '6h',
    68: '6d',
    72: '6c',
    81: '7s',
    82: '7h',
    84: '7d',
    88: '7c',
    97: '8s',
    98: '8h',
    100: '8d',
    104: '8c',
    113: '9s',
    114: '9h',
    116: '9d',
    120: '9c',
    130: 'Th',
    132: 'Td',
    136: 'Tc',
    129: 'Ts',
    152: 'Jc',
    145: 'Js',
    146: 'Jh',
    148: 'Jd',
    161: 'Qs',
    162: 'Qh',
    164: 'Qd',
    168: 'Qc',
    177: 'Ks',
    178: 'Kh',
    180: 'Kd',
    184: 'Kc',
    200: 'Ac',
    193: 'As',
    194: 'Ah',
    196: 'Ad'
  };
  static getString(int cardNum) {
    return cardNumbers[cardNum];
  }

  static getCardLetter(int cardNum) {
    return cardNumbers[cardNum].substring(0, 1);
  }

  static getCardSuit(int cardNum) {
    return cardNumbers[cardNum][1];
  }

  static List<String> getCardLetters() {
    return ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'];
  }

  static List<String> getCardSuits() {
    return ['c', 's', 'd', 'h'];
  }

  static String getCardName(int index) {
    if (index < 0 || index > 51) {
      return cardNamesInSequence[0];
    }
    return cardNamesInSequence[index];
  }
}
