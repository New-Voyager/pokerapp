import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/web-routes.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/src/sha1.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({Key key}) : super(key: key);

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final _textController =
      TextEditingController(text: TestService.gameInfo.gameCode);
  BuildContext _context;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _defaults();
    });
    super.initState();
  }

  _defaults() async {
    //await AppService.getInstance().init();
    //await AppService.getInstance().initScreenAttribs();

    Screen.init(_context);
    String deviceId = new Uuid().v4().toString();
    deviceId = sha1.convert(utf8.encode(deviceId)).toString();

    log('deviceId: $deviceId');
    final resp = await AuthService.signup(
      deviceId: deviceId,
      screenName: "webplayer",
      displayName: "webplayer",
      recoveryEmail: "webplayer@gmail.com",
    );
    if (resp['status']) {
      // save device id, device secret and jwt
      AuthModel currentUser = AuthModel(
          deviceID: deviceId,
          deviceSecret: resp['deviceSecret'],
          name: "webplayer",
          uuid: resp['uuid'],
          playerId: resp['id'],
          jwt: resp['jwt']);
      await AuthService.save(currentUser);
      AppConfig.jwt = resp['jwt'];
      final availableCoins = await AppCoinService.availableCoins();
      AppConfig.setAvailableCoins(availableCoins);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    // Check for errors
    return Scaffold(
      body: Container(
        width: 800,
        height: 800,
        color: Colors.red,
        child: Column(
          children: [
            Text('Hello'),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter gamecode',
              ),
            ),
            const SizedBox(height: 24),
            RoundRectButton2(
              text: "Join Game",
              onTap: () {
                Navigator.of(context).pushNamed(
                  WebRoutes.gameRoute,
                  arguments: {'gameCode': _textController.text},
                );
              },
              theme: AppTheme.getTheme(context),
            ),
          ],
        ),
      ),
    );
  }
}
