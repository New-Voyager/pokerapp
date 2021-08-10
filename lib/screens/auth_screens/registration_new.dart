import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
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
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: appTheme.fillInColor,
        title: Text("Debug details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              hintText: "API Server URL",
              onChanged: (val) {
                //log("VALUE : $val");
                apiUrl = val;
                setState(() {});
              },
            ),
          ],
        ),
        actions: [
          RoundedColorButton(
              text: "SAVE",
              backgroundColor: appTheme.accentColor,
              textColor: appTheme.primaryColorWithDark(0.50),
              onTapFunction: () async {
                if (apiUrl.isEmpty) {
                  toast("API url can't be empty");
                  return;
                }

                // FIRST SET THE URLS
                await AppConfig.saveApiUrl(
                  apiServer: apiUrl.trim(),
                );

                await graphQLConfiguration.init();

                Alerts.showNotification(titleText: 'API url is SET');

                Navigator.of(context).pop();
              }),
        ],
      ),
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
                text: "By creating an account, you agree with our ",
                style: AppTextStyles.T2.copyWith(
                  color: appTheme.supportingColorWithDark(0.50),
                ),
              ),
              TextSpan(
                text: "Terms of Service",
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
                text: "Privacy Policy",
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
    final appTheme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgRadialGradient(_appTheme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          floatingActionButton: IconButton(
            icon: Icon(
              Icons.bug_report,
              size: 32,
              color: _appTheme.supportingColorWithDark(0.50),
            ),
            onPressed: () => onBugIconPress(_appTheme),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDimensionsNew.getVerticalSizedBox(16.pw),
                // Logo section
                AppNameAndLogoWidget(_appTheme, _appScreenText),

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
                          labelText: _appScreenText.getText('SCREEN_NAME'),
                          keyboardType: TextInputType.name,
                          controller: _screenNameCtrl,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppStringsNew.screenNameEmptyErrorText;
                            }
                            if (value.length > 20) {
                              return AppStringsNew.screenNameLengthErrorText;
                            }
                            return null;
                          },
                          hintText: _appScreenText.getText('REQUIRED'),
                          onInfoIconPress: () {
                            toast(
                              AppStringsNew.screenNameHintToast,
                              duration: Duration(seconds: 3),
                            );
                          },
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // name
                        _buildTextFormField(
                          appTheme: appTheme,
                          labelText: _appScreenText.getText('YOUR_NAME'),
                          keyboardType: TextInputType.name,
                          controller: _nameCtrl,
                          validator: (value) {
                            if (value.length > 30) {
                              return AppStringsNew.displayNameLengthErrorText;
                            }
                            return null;
                          },
                          hintText: _appScreenText.getText('OPTIONAL'),
                          onInfoIconPress: () {
                            toast(
                              AppStringsNew.displayNameHintToast,
                              duration: Duration(seconds: 4),
                            );
                          },
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // Recover Email
                        _buildTextFormField(
                          appTheme: appTheme,
                          labelText: _appScreenText.getText('RECOVERY_EMAIL'),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailCtrl,
                          validator: (value) {
                            if (value.length > 50) {
                              return AppStringsNew.emailInvalidText;
                            } else if (value.isNotEmpty) {
                              // RegExp for email validation
                              if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value)) {
                                return AppStringsNew.emailInvalidText;
                              }
                            }
                            return null;
                          },
                          hintText: _appScreenText.getText('OPTIONAL'),
                          onInfoIconPress: () {
                            toast(
                              AppStringsNew.emailHintToast,
                              duration: Duration(seconds: 5),
                            );
                          },
                        ),

                        // sep
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // Terms and privacy text
                        _buildTermsAndPrivacyText(_appTheme),

                        RoundedColorButton(
                          backgroundColor: _appTheme.accentColor,
                          textColor: _appTheme.primaryColorWithDark(0.50),
                          text: AppStringsNew.signupButtonText,
                          fontSize: 14.dp,
                          onTapFunction: () => _handleSignUpClick(),
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
                      AppStringsNew.restoreAccountText,
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
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Center(
                    child: Text(
                      AppConfig.apiUrl,
                      style: TextStyle(fontSize: 20),
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
    toast("Opening privacy policy URL");
  }

  _openTermsOfService() {
    toast("Opening Terms and conditions URL");
  }

  _handleSignUpClick() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      log("Form is correct");
      String deviceId = new Uuid().v4().toString();
      try {
        final devId = await FlutterUdid.udid;
        deviceId = devId;
      } catch (err) {
        // couldn't get device id, use the uuid
      }

      ConnectionDialog.show(
          context: context, loadingText: AppStringsNew.loadingTextRegister);
      final resp = await AuthService.signup(
        deviceId: deviceId,
        screenName: _screenNameCtrl.text.trim(),
        displayName: _nameCtrl.text.trim(),
        recoveryEmail: _emailCtrl.text.trim(),
      );
      ConnectionDialog.dismiss(context: context);
      if (resp['status']) {
        // successful
        Alerts.showNotification(
            titleText: AppStringsNew.registrationSuccessText);

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

        // Navigate to main screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.main,
          (_) => false,
        );
      } else {
        // failed
        log("ERROR : ${resp['error']}");
        Alerts.showNotification(
          titleText: AppStringsNew.registrationFailText,
          subTitleText: resp['error'],
          duration: Duration(seconds: 5),
        );
      }
    }
  }
}
