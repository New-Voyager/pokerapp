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
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';
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
    _appScreenText = getAppTextScreen("registration");

    return Consumer(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppDimensionsNew.getVerticalSizedBox(16.pw),
                  // Logo section
                  AppNameAndLogoWidget(appTheme),

                  // restore existing account text
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Restore existing account",
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
                                return AppStringsNew.emailInvalidText;
                              }
                              // RegExp for email validation
                              if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value)) {
                                return AppStringsNew.emailInvalidText;
                              }

                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                    AppStringsNew.emailHintToast,
                                    duration: Duration(seconds: 5),
                                  );
                                },
                              ),

                              /* label texts */
                              labelText: 'Recovery email',
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

                          // get code button
                          RoundedColorButton(
                            backgroundColor: appTheme.accentColor,
                            textColor: appTheme.primaryColorWithDark(0.50),
                            text: AppStringsNew.getCodeButtonText,
                            fontSize: 14.dp,
                            onTapFunction: () => _handleGetCode(context),
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
                                        return "Enter recovery code";
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
                                          AppStringsNew
                                              .recoveryCodeInfoToastText,
                                          duration: Duration(seconds: 4),
                                        );
                                      },
                                    ),

                                    /* label texts */
                                    labelText: 'Recovery email',
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
                                RoundedColorButton(
                                  backgroundColor: appTheme.accentColor,
                                  textColor:
                                      appTheme.primaryColorWithDark(0.50),
                                  text: AppStringsNew.restoreButtonText,
                                  fontSize: 14.dp,
                                  onTapFunction: () => _handleRestoreClick(
                                    context,
                                  ),
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
                              child: Text(AppStringsNew.signupButtonText,
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
      ),
    );
  }

  _handleRestoreClick(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // Validate code with server and navigate to main screen if success
    if (_formKey.currentState.validate()) {
      ConnectionDialog.show(
          context: context, loadingText: "Restoring account...");

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
        Alerts.showNotification(titleText: AppStringsNew.restoreSuccessText);

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
      ConnectionDialog.show(context: context, loadingText: "Sending code...");
      final result = await AuthService.sendRecoveryCode(
        recoveryEmail: _emailCtrl.text.trim(),
      );
      if (result['status']) {
        Alerts.showNotification(
          titleText: "Code sent to recovery mail.",
          duration: Duration(seconds: 4),
        );
        setState(() {
          _restoreVisible = true;
        });
      } else {
        Alerts.showNotification(
          titleText: "Failed to send code.",
          subTitleText: result['error'],
          duration: Duration(seconds: 4),
        );
      }
      ConnectionDialog.dismiss(context: context);
    }
  }
}
