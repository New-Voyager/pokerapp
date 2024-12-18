import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:uuid/uuid.dart';

class RestoreAccountScreen extends StatefulWidget {
  const RestoreAccountScreen({Key key}) : super(key: key);

  @override
  _RestoreAccountScreenState createState() => _RestoreAccountScreenState();
}

class _RestoreAccountScreenState extends State<RestoreAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codeCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  AppTextScreen _appScreenText;
  bool _restoreVisible = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);
    _appScreenText = getAppTextScreen("recoveraccount");

    return Container(
      decoration: AppDecorators.bgRadialGradient(appTheme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDimensionsNew.getVerticalSizedBox(16.pw),

                BackArrowWidget(
                  onBackHandle: () => Navigator.pop(context),
                ),

                // Logo section
                AppNameAndLogoWidget(appTheme, _appScreenText),

                // restore existing account text
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    _appScreenText['restoreExistingAccount'],
                    style: AppTextStyles.T1.copyWith(
                      color: appTheme.supportingColorWithDark(0.50),
                    ),
                  ),
                ),

                // Form
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Recover Email
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailCtrl,
                          validator: (value) {
                            if (value.length > 50) {
                              return _appScreenText['invalidEmail'];
                            }
                            // RegExp for email validation
                            if (!RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value)) {
                              return _appScreenText['invalidEmail'];
                            }

                            return null;
                          },
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
                              onPressed: () {
                                toast(
                                  _appScreenText['recoveryEmailHint'],
                                  duration: Duration(seconds: 5),
                                );
                              },
                            ),

                            /* label texts */
                            labelText: _appScreenText['recoveryEmail'],
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
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // get code button
                        RoundRectButton(
                          text: _appScreenText['getCode'],
                          fontSize: 14.dp,
                          onTap: () => _handleGetCode(context),
                          theme: appTheme,
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(8),

                        // Name
                        Visibility(
                          visible: _restoreVisible,
                          child: Column(
                            children: [
                              // sep
                              AppDimensionsNew.getVerticalSizedBox(24),

                              // form
                              TextFormField(
                                controller: _codeCtrl,
                                validator: (value) {
                                  if (_restoreVisible) {
                                    if (value.isEmpty) {
                                      return _appScreenText[
                                          "enterRecoveryCode"];
                                    }
                                  }
                                  return null;
                                },
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Image.asset(
                                      AppAssetsNew.pathGameTypeChipImage,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.info,
                                      color: appTheme
                                          .supportingColorWithDark(0.50),
                                    ),
                                    onPressed: () {
                                      toast(
                                        _appScreenText[
                                            'recoveryCodeInfoToastText'],
                                        duration: Duration(seconds: 4),
                                      );
                                    },
                                  ),

                                  /* label texts */
                                  labelText: _appScreenText['recoveryEmail'],
                                  labelStyle: AppTextStyles.T0.copyWith(
                                    color: appTheme.accentColor,
                                  ),

                                  /* other */
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  filled: true,
                                  fillColor: appTheme.fillInColor,
                                  alignLabelWithHint: true,
                                ),
                              ),

                              // sep
                              AppDimensionsNew.getVerticalSizedBox(16),

                              // button

                              RoundRectButton(
                                text: _appScreenText['restore'],
                                fontSize: 14.dp,
                                onTap: () => _handleRestoreClick(
                                  context,
                                ),
                                theme: appTheme,
                              ),
                            ],
                          ),
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(24),

                        // signup text button
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Text(_appScreenText['signup'],
                                style: AppTextStyles.T2.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: appTheme.accentColor,
                                )),
                          ),
                        ),
                      ],
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

  _handleRestoreClick(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // Validate code with server and navigate to main screen if success
    if (_formKey.currentState.validate()) {
      ConnectionDialog.show(
          context: context, loadingText: _appScreenText['"restoreAccount"']);

      // Get Device ID
      String deviceId = new Uuid().v4().toString();
      try {
        final devId = await FlutterUdid.udid;
        deviceId = devId;
      } catch (err) {
        // couldn't get device id, use the uuid
      }
      final result = await AuthService.loginUsingRecoveryCode(
        recoveryEmail: _emailCtrl.text.trim(),
        code: _codeCtrl.text.trim(),
        deviceId: deviceId,
      );

      if (result['status'] == true) {
        ConnectionDialog.dismiss(context: context);
        // successful
        Alerts.showNotification(
            titleText: _appScreenText['restoreSuccessText']);

        // save device id, device secret and jwt
        AuthModel currentUser = AuthModel(
          deviceID: deviceId,
          deviceSecret: result['deviceSecret'],
          name: result['name'],
          uuid: result['uuid'],
          playerId: result['id'],
          jwt: result['jwt'],
        );
        await AuthService.save(currentUser);
        AppConfig.jwt = result['jwt'];
        // Navigate to main screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.main,
          (_) => false,
        );
      } else {
        ConnectionDialog.dismiss(context: context);
        Alerts.showNotification(titleText: result['error']);
      }
    }
  }

  _handleGetCode(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // Make API Call to get code
    if (_formKey.currentState.validate()) {
      ConnectionDialog.show(
          context: context, loadingText: _appScreenText["sendingCode"]);
      final result = await AuthService.sendRecoveryCode(
        recoveryEmail: _emailCtrl.text.trim(),
      );
      if (result['status']) {
        Alerts.showNotification(
          titleText: _appScreenText["codeSentToRecoveryEmail"],
          duration: Duration(seconds: 4),
        );
        setState(() {
          _restoreVisible = true;
        });
      } else {
        Alerts.showNotification(
          titleText: _appScreenText["failedToSendCode"],
          subTitleText: result['error'],
          duration: Duration(seconds: 4),
        );
      }
      ConnectionDialog.dismiss(context: context);
    }
  }
}
