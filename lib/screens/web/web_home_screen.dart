import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pokerapp/build_info.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/util_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/src/sha1.dart';
import 'package:device_info_plus/device_info_plus.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({Key key}) : super(key: key);

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final _textController = TextEditingController();
  AppTextScreen _appScreenText;
  AppTheme _appTheme;
  bool loading = true;
  WebBrowserInfo webBrowserInfo;
  // BuildContext _context;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("registration");
    _appTheme = AppTheme.getTheme(context);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    deviceInfo.webBrowserInfo.then((value) {
      webBrowserInfo = value;
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    _appTheme = AppTheme.getTheme(context);
    if (loading) {
      return CircularProgressIndicator();
    }
    String info = "Version: ${versionNumber} Updated: ${releaseDate}";
    info = info + "\n";
    info = info +
        'Browser: ${webBrowserInfo.platform} Agent: ${webBrowserInfo.userAgent} AppName: ${webBrowserInfo.userAgent}';
    // Check for errors
    return WillPopScope(
        onWillPop: () async {
          final result = await showYesNoDialog(
              context, "Confirm", "Would you like to exit?");
          return result;
        },
        child: Container(
            decoration: AppDecorators.bgImage(_appTheme),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AppDimensionsNew.getVerticalSizedBox(16),
                          // Logo section
                          AppNameAndLogoWidget(_appTheme, _appScreenText),
                          AppDimensionsNew.getVerticalSizedBox(16),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          AppColorsNew.yellowAccentColor,
                                      radius: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () async {
                                          final dynamic result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                            WebRoutes.new_game_settings,
                                          );
                                          if (result != null) {
                                            /* show game settings dialog */
                                            await NewGameSettings2.show(
                                              context,
                                              clubCode: "",
                                              mainGameType: result['gameType'],
                                              subGameTypes: List.from(
                                                    result['gameTypes'],
                                                  ) ??
                                                  [],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    AppDimensionsNew.getVerticalSizedBox(16),
                                    Text(
                                      "Host a Game",
                                      style: AppStylesNew.valueTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextInputWidget.buildTextFormField(
                                      controller: _textController,
                                      validator: (_) {
                                        if (_textController.text.isEmpty) {
                                          return "Enter a valid game code";
                                        }
                                        return null;
                                      },
                                      hintText: "Enter Game code",
                                      labelText: "Game code",
                                      onInfoIconPress: () {},
                                      appTheme: _appTheme,
                                    ),
                                    const SizedBox(height: 24),
                                    ButtonWidget(
                                        text: "Join Game",
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            WebRoutes.game_play +
                                                "/" +
                                                _textController.text,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          Divider(
                            height: 24,
                            color: Colors.grey,
                            indent: 32,
                            endIndent: 32,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          AppColorsNew.yellowAccentColor,
                                      radius: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () async {
                                          _handleCreateTournment(context);
                                        },
                                      ),
                                    ),
                                    AppDimensionsNew.getVerticalSizedBox(16),
                                    Text(
                                      "Create Tournament",
                                      style: AppStylesNew.valueTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          AppColorsNew.yellowAccentColor,
                                      radius: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.list),
                                        onPressed: () async {
                                          _handleListTournments(context);
                                        },
                                      ),
                                    ),
                                    AppDimensionsNew.getVerticalSizedBox(16),
                                    Text(
                                      "List Tournaments",
                                      style: AppStylesNew.valueTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          Row(children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ButtonWidget(
                                      text: "Try It!",
                                      onTap: () {
                                        startDemoGame(context);
                                      }),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 36,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      info,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.T3.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )));
  }

  void startDemoGame(BuildContext context) async {
    final demoGame = NewGameModel.demoGame();
    String gameCode = await GameService.configurePlayerGame(demoGame);

    if (gameCode == null) return;

    // wait for all the bots taken the seats
    ConnectionDialog.show(context: context, loadingText: 'Starting demo game');
    try {
      while (true) {
        final gameInfo = await GameService.getGameInfo(gameCode);
        if (gameInfo.availableSeats.length == 1) {
          break;
        } else {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } catch (err) {}
    ConnectionDialog.dismiss(context: context);
    Navigator.of(context).pushNamed(
      WebRoutes.game_play + "/" + gameCode,
    );
  }
// _defaults() async {
//     //await AppService.getInstance().init();
//     //await AppService.getInstance().initScreenAttribs();

//     Screen.init(_context);
//     String deviceId = new Uuid().v4().toString();
//     deviceId = sha1.convert(utf8.encode(deviceId)).toString();

//     log('deviceId: $deviceId');
//     final resp = await AuthService.signup(
//       deviceId: deviceId,
//       screenName: "webplayer",
//       displayName: "webplayer",
//       recoveryEmail: "webplayer@gmail.com",
//     );
//     if (resp['status']) {
//       // save device id, device secret and jwt
//       AuthModel currentUser = AuthModel(
//           deviceID: deviceId,
//           deviceSecret: resp['deviceSecret'],
//           name: "webplayer",
//           uuid: resp['uuid'],
//           playerId: resp['id'],
//           jwt: resp['jwt']);
//       await AuthService.save(currentUser);
//       AppConfig.jwt = resp['jwt'];
//       final availableCoins = await AppCoinService.availableCoins();
//       AppConfig.setAvailableCoins(availableCoins);
//       setState(() {});
//     }
//   }

  _handleCreateTournment(BuildContext context) async {
    final id = await hostTournament(context);
    if (id == null) {
      return;
    }
    Navigator.of(context).pushNamed(
      WebRoutes.tournaments,
    );
  }

  _handleListTournments(BuildContext context) {
    Navigator.pushNamed(
      context,
      WebRoutes.tournaments,
    );
  }
}
