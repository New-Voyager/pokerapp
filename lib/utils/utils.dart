import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:pokerapp/screens/game_screens/tournament/tournament_settings.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:provider/provider.dart';

const _cacheStalePeriod = const Duration(days: 1);
const _maxCacheObjects = 50;

class ImageCacheManager {
  static const _key = 'app-image-cache-key';
  static CacheManager instance = CacheManager(
    Config(
      _key,
      stalePeriod: _cacheStalePeriod,
      maxNrOfCacheObjects: _maxCacheObjects,
      repo: JsonCacheInfoRepository(databaseName: _key),
      fileService: HttpFileService(),
    ),
  );
}

class Screen {
  static bool initialized = false;
  final Size _size;
  final double _devicePixelRatio;
  static double _diagonalInches;
  Screen(this._size, this._devicePixelRatio);

  static Screen _screen;
  static void init(BuildContext c) {
    initialized = true;
    final query = MediaQuery.of(c);
    _screen = new Screen(query.size, query.devicePixelRatio);
  }

  static double get _ppi =>
      (PlatformUtils.isAndroid || PlatformUtils.isIOS) ? 150 : 96;

  static double get devicePixelRatio {
    return _screen._devicePixelRatio;
  }

  static bool get isLargeScreen {
    return Screen.screenSizeInches >= 7;
  }

  static int get screenSize {
    int diagonalSize = diagonalInches.floor();
    if (PlatformUtils.isIOS) {
      diagonalSize = diagonalInches.floor();
    }
    return diagonalSize.toInt();
  }

  static double get screenSizeInches {
    return double.parse(Screen.diagonalInches.toStringAsPrecision(2));
  }

  static Size get physicalSize {
    return Size(_screen._size.width * _screen._devicePixelRatio,
        _screen._size.height * _screen._devicePixelRatio);
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
  static double get diagonalInches {
    if (_diagonalInches != null) {
      return _diagonalInches;
    }
    _diagonalInches = diagonal / _ppi;
    return _diagonalInches;
  }
}

class DeviceInfo {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static DeviceInfo _deviceInfo;

  static Future<void> init() async {
    _deviceInfo = new DeviceInfo();
    await _deviceInfo.initPlateformData();
  }

  static DeviceInfo get deviceInfo => _deviceInfo;
  static String get name {
    return _deviceInfo._deviceData['name'].toString();
  }

  static bool get physicalDevice =>
      _deviceInfo._deviceData['isPhysicalDevice'] ?? false;

  Future<void> initPlateformData() async {
    try {
      if (PlatformUtils.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (PlatformUtils.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  static String get model {
    if (PlatformUtils.isIOS) {
      return _deviceInfo._deviceData['model'];
    } else if (PlatformUtils.isAndroid) {
      return _deviceInfo._deviceData['model'];
    }
    return 'Unknown';
  }

  static String get version {
    if (PlatformUtils.isIOS) {
      return _deviceInfo._deviceData['systemVersion'];
    } else if (PlatformUtils.isAndroid) {
      return _deviceInfo._deviceData['version.sdkInt'].toString();
    }
    return 'Unknown';
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
    String model = data.utsname.machine.iOSProductName;
    if (model.contains('Simulator')) {
      model = data.name;
    }

    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': model,
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

class HelperUtils {
  static String buildGameTypeStrFromList(List<GameType> gamesList) {
    if (gamesList != null) {
      String str = "(";
      for (var type in gamesList) {
        str += "${gameTypeShortStr(type)}, ";
      }
      str += ")";
      return "${str.replaceFirst(", )", ")")}";
    }
    return "";
  }

  static buildGameTypeStrFromListDynamic(List gamesList) {
    if (gamesList != null) {
      String str = "(";
      for (var type in gamesList) {
        str += "${gameTypeShortStr(gameTypeFromStr(type))}, ";
      }
      str += ")";
      return "${str.replaceFirst(", )", ")")}";
    }
    return "";
  }

  static String getClubShortName(String clubName) {
    var clubNameSplit = clubName.split(' ');
    if (clubNameSplit.length >= 2)
      return '${clubNameSplit[0].substring(0, 1)}${clubNameSplit[1].substring(0, 1)}'
          .toUpperCase();

    try {
      return '${clubName.substring(0, 2)}'.toUpperCase();
    } catch (e) {
      return clubName.toUpperCase();
    }
  }
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  DateTime ret =
      dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));

  ret = DateTime(ret.year, ret.month, ret.day, 23, 59, 59);
  return ret;
}

class ProfileClass {
  Stopwatch gameLoading;
  Stopwatch initStateTime;
  Stopwatch gameInfoFetch;
  Stopwatch queryCurrentHand;
  Stopwatch boardBuildTime;
  Stopwatch gameComServiceTime;
  Stopwatch gameStateTime;

  List<String> profileLogs = [];
  void startGameLoading() {
    gameLoading = Stopwatch();
    gameLoading.start();
  }

  void stopGameLoading() {
    gameLoading.stop();
    developer.log(
        'Performance: Game loading time: ${gameLoading.elapsedMilliseconds}ms');
    profileLogs.add(
        'Performance: Game loading time: ${gameLoading.elapsedMilliseconds}ms');
  }

  void startInitStateTime() {
    initStateTime = Stopwatch();
    initStateTime.start();
  }

  void stopInitStateTime() {
    initStateTime.stop();
    developer.log(
        'Performance: Init state time: ${initStateTime.elapsedMilliseconds}ms');
    profileLogs.add(
        'Performance: Init state time: ${initStateTime.elapsedMilliseconds}ms');
  }

  void startGameInfoFetch() {
    gameInfoFetch = Stopwatch();
    gameInfoFetch.start();
  }

  void stopGameInfoFetch() {
    gameInfoFetch.stop();
    developer.log(
        'Performance: Game info fetch time: ${gameInfoFetch.elapsedMilliseconds}ms');
    profileLogs.add(
        'Performance: Game info fetch time: ${gameInfoFetch.elapsedMilliseconds}ms');
  }

  void startQueryCurrentHand() {
    queryCurrentHand = Stopwatch();
    queryCurrentHand.start();
  }

  void stopQueryCurrentHand() {
    queryCurrentHand.stop();
    developer.log(
        'Performance: Query current hand time: ${queryCurrentHand.elapsedMilliseconds}ms');
    profileLogs.add(
        'Performance: Query current hand time: ${queryCurrentHand.elapsedMilliseconds}ms');
  }

  void startBoardBuildTime() {
    boardBuildTime = Stopwatch()..start();
  }

  void stopBoardBuildTime() {
    boardBuildTime.stop();
    developer.log(
        'Performance: Board build time: ${boardBuildTime.elapsedMilliseconds}ms');
    profileLogs.add(
        'Performance: Board build time: ${boardBuildTime.elapsedMilliseconds}ms');
  }

  void startGameServiceTime() {
    gameComServiceTime = Stopwatch()..start();
  }

  void stopGameServiceTime() {
    gameComServiceTime.stop();
    profileLogs.add(
        'Performance: Game com service time: ${gameComServiceTime.elapsedMilliseconds}ms');
  }

  void startGameStateTime() {
    gameStateTime = Stopwatch()..start();
  }

  void stopGameStateTime() {
    gameStateTime.stop();
    profileLogs.add(
        'Performance: Game state initialize time: ${gameStateTime.elapsedMilliseconds}ms');
  }
}

ProfileClass Profile = ProfileClass();

// Create a tournemnt
Future<int> hostTournament(BuildContext context) async {
  int tournamentId = await TournamentSettingsView.show(
    context,
  );
  if (tournamentId == null) return null;
  Alerts.showNotification(titleText: 'Tournament: $tournamentId is created');
  final natsClient = Provider.of<Nats>(context, listen: false);
  natsClient.subscribeTournamentMessages(tournamentId);
  return tournamentId;
}
