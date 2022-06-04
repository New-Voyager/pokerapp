import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/models/ui/app_theme_styles.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/appinfo_service.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToNextScreen(bool isAuthenticated) {
    if (PlatformUtils.isWeb) {
      Navigator.pushReplacementNamed(
        context,
        isAuthenticated ? WebRoutes.home : WebRoutes.registration,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        isAuthenticated ? Routes.main : Routes.registration,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _initializeSettings();
      _decideNavigation();
    });
  }

  Future<void> _initializeSettings() async {
    await AssetHiveStore.openAssetStore();
    // initialize asset store with default value
    await AssetService.updateBundledAssets();
    await AudioService.init();

    // this function call will NOT end until we have internet access
    if (PlatformUtils.isWeb) {
      return;
    }
    await context.read<NetworkChangeListener>().checkInternet();
  }

  void _decideNavigation() async {
    /*
      By default navigate to login screen, 
      if config has device id and device secret then navigates to main screen.
      */
    bool goToLoginScreen = true;
    try {
      // first get app information
      await AppInfoService.getAppInfo();
    } catch (err) {}
    if (AppConfig.deviceId != null || AppConfig.deviceSecret != null) {
      try {
        // generate jwt
        final resp = await AuthService.newlogin(
            AppConfig.deviceId, AppConfig.deviceSecret);
        if (resp['status']) {
          // Need to initialize before queries
          await graphQLConfiguration.init();

          // successfully logged in
          AppConfig.jwt = resp['jwt'];
          // save device id, device secret and jwt
          AuthModel currentUser = AuthModel(
              deviceID: AppConfig.deviceId,
              deviceSecret: AppConfig.deviceSecret,
              name: resp['name'],
              uuid: resp['uuid'],
              playerId: resp['id'],
              jwt: resp['jwt']);
          await AuthService.save(currentUser);
          AppConfig.jwt = resp['jwt'];
          final availableCoins = await AppCoinService.availableCoins();
          AppConfig.setAvailableCoins(availableCoins);

          // download assets (show status bar)
          try {
            await AssetService.refresh();
          } catch (err) {
            log(err.toString());
          }
          await playerState.open();

          // read announcments
          final announcements = await GameService.getSystemAnnouncements();

          // if there are announcements marked as important, show in a dialog
          List<AnnouncementModel> important = [];
          int unreadAnnouncements = 0;
          for (final announcement in announcements) {
            if (announcement.createdAt
                .isAfter(playerState.lastReadSysAnnounceDate)) {
              if (announcement.isImportant) {
                important.add(announcement);
              }
              // playerState.updateSysAnnounceReadDate();
              unreadAnnouncements++;
            }
          }
          playerState.unreadAnnouncements = unreadAnnouncements;
          goToLoginScreen = false;
        }
      } catch (err) {
        goToLoginScreen = true;
      }
    }
    _navigateToNextScreen(!goToLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    // TODO REMOVE THIS FOR PRODUCTION
    Upgrader().clearSavedSettings(); // REMOVE this for release builds

    final theme = AppTheme.getTheme(context);
    final themeData = HiveDatasource.getInstance
        .getBox(BoxType.USER_SETTINGS_BOX)
        .get("theme");
    String selectedStyle = 'default';
    if (themeData != null) {
      final style = getAppStyle(selectedStyle);
      theme.updateThemeData(
        AppThemeData(
          style: style,
          tableAssetId: themeData['tableAssetId'],
          backDropAssetId: themeData['backDropAssetId'],
          cardBackAssetId: themeData['cardBackAssetId'],
          cardFaceAssetId: themeData['cardFaceAssetId'],
          betAssetId: themeData['betAssetId'],
        ),
      );
    }
    return UpgradeAlert(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset('assets/images/splash.png'),
        ),
      ),
    );
  }
}
