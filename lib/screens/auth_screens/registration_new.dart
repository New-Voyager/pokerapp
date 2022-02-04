import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/flavor_config.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreenNew extends StatefulWidget {
  const RegistrationScreenNew({Key key}) : super(key: key);

  @override
  _RegistrationScreenNewState createState() => _RegistrationScreenNewState();
}

class _RegistrationScreenNewState extends State<RegistrationScreenNew> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _screenNameCtrl = TextEditingController();
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TapGestureRecognizer _termsClick = TapGestureRecognizer();
  TapGestureRecognizer _privacyClick = TapGestureRecognizer();
  AppTextScreen _appScreenText;
  AppTheme _appTheme;

  Widget _buildTextFormField({
    TextInputType keyboardType,
    @required TextEditingController controller,
    @required void validator(String _),
    @required String hintText,
    @required void onInfoIconPress(),
    @required String labelText,
    @required AppTheme appTheme,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        /* border */
        border: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.primaryColorWithDark(),
        ),
        errorBorder: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.negativeOrErrorColor,
        ),
        focusedBorder: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.accentColorWithDark(),
        ),

        /* icons - prefix, suffix */
        prefixIcon: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            AppAssetsNew.pathGameTypeChipImage,
            height: 16,
            width: 16,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.info,
            color: appTheme.supportingColorWithDark(0.50),
          ),
          onPressed: onInfoIconPress,
        ),

        /* hint & label texts */
        hintText: hintText,
        hintStyle: AppTextStyles.T3.copyWith(
          color: appTheme.supportingColorWithDark(0.60),
        ),
        labelText: labelText,
        labelStyle: AppTextStyles.T0.copyWith(
          color: appTheme.accentColor,
        ),

        /* other */
        contentPadding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: appTheme.fillInColor,
        alignLabelWithHint: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("registration");
    _appTheme = AppTheme.getTheme(context);
  }

  void onBugIconPress(AppTheme appTheme) {
    String apiUrl = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: appTheme.fillInColor,
          title: Text(_appScreenText['debugDetails']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CardFormTextField(
                theme: _appTheme,
                hintText: _appScreenText['apiServerUrl'],
                onChanged: (val) {
                  //log("VALUE : $val");
                  apiUrl = val;
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            RoundRectButton(
                text: _appScreenText["save"],
                onTap: () async {
                  if (apiUrl.isEmpty) {
                    toast(_appScreenText['apiUrlCantBeEmpty']);
                    return;
                  }

                  // FIRST SET THE URLS
                  await AppConfig.saveApiUrl(
                    apiServer: apiUrl.trim(),
                  );

                  await graphQLConfiguration.init();

                  Alerts.showNotification(
                      titleText: _appScreenText['apiUrlIsSet']);

                  Navigator.of(context).pop();
                },
                theme: appTheme),
          ],
        );
      },
    );
  }

  void onLoginAsBot(AppTheme appTheme) {
    String botName = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: appTheme.fillInColor,
          title: Text('Login As Bot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CardFormTextField(
                theme: _appTheme,
                hintText: 'Bot Name',
                onChanged: (val) {
                  //log("VALUE : $val");
                  botName = val;
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            RoundRectButton(
                text: 'Login',
                onTap: () async {
                  if (botName.isEmpty) {
                    toast('Please specify bot name');
                    return;
                  }

                  ConnectionDialog.show(
                      context: context,
                      loadingText: 'Logging in as bot $botName');

                  int playerId = int.tryParse(botName);
                  Map<String, dynamic> resp;
                  if (playerId != null && playerId != 0) {
                    // login with player id
                    resp = await AuthService.loginPlayer(playerId);
                  } else {
                    // login with bot name
                    resp = await AuthService.loginBot(botName);
                  }

                  if (resp['status']) {
                    // successful
                    Alerts.showNotification(titleText: 'Logging in successful');
                    // save device id, device secret and jwt
                    AuthModel currentUser = AuthModel(
                        deviceID: resp['deviceId'],
                        deviceSecret: resp['deviceSecret'],
                        name: _screenNameCtrl.text,
                        uuid: resp['uuid'],
                        playerId: resp['id'],
                        jwt: resp['jwt']);
                    await AuthService.save(currentUser);
                    AppConfig.jwt = resp['jwt'];

                    final availableCoins =
                        await AppCoinService.availableCoins();
                    AppConfig.setAvailableCoins(availableCoins);
                    try {
                      await AssetService.refresh();
                    } catch (err) {
                      log(err.toString());
                    }
                    ConnectionDialog.dismiss(context: context);
                    Navigator.of(context).pop();

                    // Navigate to main screen
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.main,
                      (_) => false,
                    );
                  } else {
                    ConnectionDialog.dismiss(context: context);
                    Navigator.of(context).pop();
                    // failed
                    log("ERROR : ${resp['error']}");
                    Alerts.showNotification(
                      titleText: 'login failed',
                      subTitleText: resp['error'],
                      duration: Duration(seconds: 5),
                    );
                  }
                },
                theme: appTheme),
          ],
        );
      },
    );
  }

  Widget _buildTermsAndPrivacyText(AppTheme appTheme) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _appScreenText['agreement'],
                style: AppTextStyles.T2.copyWith(
                  color: appTheme.supportingColorWithDark(0.50),
                ),
              ),
              TextSpan(
                text: _appScreenText["toc"],
                style: AppTextStyles.T2.copyWith(
                  decoration: TextDecoration.underline,
                  color: appTheme.supportingColorWithDark(0.50),
                ),
                recognizer: _termsClick..onTap = _openTermsOfService,
              ),
              TextSpan(
                text: " & ",
                style: AppTextStyles.T2.copyWith(
                  color: appTheme.supportingColorWithDark(0.50),
                ),
              ),
              TextSpan(
                text: _appScreenText["policy"],
                style: AppTextStyles.T2.copyWith(
                  decoration: TextDecoration.underline,
                  color: appTheme.supportingColorWithDark(0.50),
                ),
                recognizer: _privacyClick..onTap = _openPrivacyPolicy,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool isDevMode = !appState.isProd;
    Widget devButtons = null;
    if (isDevMode) {
      devButtons = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.bug_report,
              size: 48.pw,
              color: _appTheme.supportingColorWithDark(0.50),
            ),
            onPressed: () => onBugIconPress(_appTheme),
          ),
          SizedBox(height: 10.dp),
          IconButton(
            icon: Icon(
              Icons.person,
              size: 48.pw,
              color: _appTheme.supportingColorWithDark(0.50),
            ),
            onPressed: () => onLoginAsBot(_appTheme),
          ),
          SizedBox(height: 100.dp),
        ],
      );
    }
    final appTheme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgImage(_appTheme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          floatingActionButton: devButtons,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDimensionsNew.getVerticalSizedBox(16.pw),
                // Logo section
                AppNameAndLogoWidget(_appTheme, _appScreenText),
                AppDimensionsNew.getVerticalSizedBox(16.pw),

                // Form
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // screen name
                        _buildTextFormField(
                          appTheme: appTheme,
                          labelText: _appScreenText['screenName'],
                          keyboardType: TextInputType.name,
                          controller: _screenNameCtrl,
                          validator: (value) {
                            if (value.isEmpty) {
                              return _appScreenText['screenNameIsRequired'];
                            }
                            if (value.length > 20) {
                              return _appScreenText["screenValidLength"];
                            }
                            return null;
                          },
                          hintText: _appScreenText['required'],
                          onInfoIconPress: () {
                            toast(
                              _appScreenText['screenNameRequired'],
                              duration: Duration(seconds: 3),
                            );
                          },
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // // name
                        // _buildTextFormField(
                        //   appTheme: appTheme,
                        //   labelText: _appScreenText['yourName'],
                        //   keyboardType: TextInputType.name,
                        //   controller: _nameCtrl,
                        //   validator: (value) {
                        //     if (value.length > 30) {
                        //       return _appScreenText['displayNameValidLength'];
                        //     }
                        //     return null;
                        //   },
                        //   hintText: _appScreenText['optional'],
                        //   onInfoIconPress: () {
                        //     toast(
                        //       _appScreenText['yourNameHint'],
                        //       duration: Duration(seconds: 4),
                        //     );
                        //   },
                        // ),

                        // // sep
                        // AppDimensionsNew.getVerticalSizedBox(16),

                        // // Recover Email
                        // _buildTextFormField(
                        //   appTheme: appTheme,
                        //   labelText: _appScreenText['recoveryEmail'],
                        //   keyboardType: TextInputType.emailAddress,
                        //   controller: _emailCtrl,
                        //   validator: (value) {
                        //     if (value.length > 50) {
                        //       return _appScreenText['invalidEmail'];
                        //     } else if (value.isNotEmpty) {
                        //       // RegExp for email validation
                        //       if (!RegExp(
                        //               r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        //           .hasMatch(value)) {
                        //         return _appScreenText['invalidEmail'];
                        //       }
                        //     }
                        //     return null;
                        //   },
                        //   hintText: _appScreenText['optional'],
                        //   onInfoIconPress: () {
                        //     toast(
                        //       _appScreenText['recoveryEmailHint'],
                        //       duration: Duration(seconds: 5),
                        //     );
                        //   },
                        // ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // Terms and privacy text
                        _buildTermsAndPrivacyText(_appTheme),

                        RoundRectButton(
                          text: _appScreenText['signup'],
                          fontSize: 14.dp,
                          onTap: () => _handleSignUpClick(),
                          theme: appTheme,
                        ),
                      ],
                    ),
                  ),
                ),

                // restore account text
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.restore_account);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _appScreenText['restoreAccount'],
                      style: AppTextStyles.T2.copyWith(
                        decoration: TextDecoration.underline,
                        color: _appTheme.accentColor,
                      ),
                    ),
                  ),
                ),

                /* ---- DEBUG REALM ---- */

                // seperator
                SizedBox(height: 100),
                Visibility(
                  visible: isDevMode,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Text(
                        AppConfig.apiUrl,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _openPrivacyPolicy() {
    Navigator.of(context).pushNamed(Routes.privacy_policy);
  }

  _openTermsOfService() {
    Navigator.of(context).pushNamed(Routes.terms_conditions);
  }

  _handleSignUpClick() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      log("Form is correct");

      String deviceId = new Uuid().v4().toString();
      if (_emailCtrl.text.trim().isNotEmpty) {
        // generate sha1 from email address
        deviceId = sha1.convert(utf8.encode(_emailCtrl.text)).toString();
      } else {
        try {
          final devId = await FlutterUdid.udid;
          deviceId = devId;
        } catch (err) {
          // couldn't get device id, use the uuid
        }
      }

      ConnectionDialog.show(
          context: context, loadingText: _appScreenText['registering']);
      final resp = await AuthService.signup(
        deviceId: deviceId,
        screenName: _screenNameCtrl.text.trim(),
        displayName: _nameCtrl.text.trim(),
        recoveryEmail: _emailCtrl.text.trim(),
      );
      if (resp['status']) {
        // successful
        Alerts.showNotification(
            titleText: _appScreenText['registrationSuccess']);

        // save device id, device secret and jwt
        AuthModel currentUser = AuthModel(
            deviceID: deviceId,
            deviceSecret: resp['deviceSecret'],
            name: _screenNameCtrl.text,
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
        ConnectionDialog.dismiss(context: context);

        // Navigate to main screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.main,
          (_) => false,
        );
      } else {
        ConnectionDialog.dismiss(context: context);
        // failed
        log("ERROR : ${resp['error']}");
        Alerts.showNotification(
          titleText: _appScreenText['registrationFailed'],
          subTitleText: resp['error'],
          duration: Duration(seconds: 5),
        );
      }
    }
  }
}
