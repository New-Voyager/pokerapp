bool _isAndriod = false;
bool _isWeb = false;
bool _isIOS = false;

class PlatformUtils {
  static bool get isAndroid => _isAndriod;
  static bool get isWeb => _isWeb;
  static bool get isIOS => _isIOS;
  static void set isAndroid(bool value) => _isAndriod = value;
  static void set isWeb(bool value) => _isWeb = value;
  static void set isIOS(bool value) => _isIOS = value;
}
