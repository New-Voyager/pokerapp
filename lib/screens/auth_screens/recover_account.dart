import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
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

  bool _restoreVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
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
                AppNameAndLogoWidget(),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    "Restore existing account",
                    style:
                        AppStylesNew.labelTextStyle.copyWith(fontSize: 12.dp),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            focusedBorder: AppStylesNew.focusBorderStyle,

                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                color: AppColorsNew.labelColor,
                              ),
                              onPressed: () {
                                toast(
                                  AppStringsNew.emailHintToast,
                                  duration: Duration(seconds: 5),
                                );
                              },
                            ),
                            errorBorder: AppStylesNew.errorBorderStyle,
                            // hintText: "Recovery email (optional)",
                            // hintStyle: TextStyle(
                            //   color: AppColorsNew.labelColor,
                            // ),
                            labelText: AppStringsNew.emailLabelText,
                            labelStyle: AppStylesNew.labelTextFieldStyle,
                            filled: true,
                            fillColor: AppColorsNew.actionRowBgColor,
                            alignLabelWithHint: true,
                            border: AppStylesNew.borderStyle,
                          ),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(16),

                        RoundedColorButton(
                          backgroundColor: AppColorsNew.yellowAccentColor,
                          text: AppStringsNew.getCodeButtonText,
                          fontSize: 14.dp,
                          textColor: AppColorsNew.darkGreenShadeColor,
                          onTapFunction: () => _handleGetCode(context),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        // Name
                        Visibility(
                          visible: _restoreVisible,
                          child: Column(
                            children: [
                              AppDimensionsNew.getVerticalSizedBox(24),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  focusedBorder: AppStylesNew.focusBorderStyle,
                                  labelStyle: AppStylesNew.labelTextFieldStyle,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
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
                                      color: AppColorsNew.labelColor,
                                    ),
                                    onPressed: () {
                                      toast(
                                        AppStringsNew.recoveryCodeInfoToastText,
                                        duration: Duration(seconds: 4),
                                      );
                                    },
                                  ),
                                  errorBorder: AppStylesNew.errorBorderStyle,
                                  //hintText: "Your Name (optional)",
                                  labelText:
                                      AppStringsNew.recoveryCodeLabelText,
                                  filled: true,
                                  fillColor: AppColorsNew.actionRowBgColor,
                                  alignLabelWithHint: true,
                                  border: AppStylesNew.borderStyle,
                                ),
                              ),
                              AppDimensionsNew.getVerticalSizedBox(16),
                              RoundedColorButton(
                                backgroundColor: AppColorsNew.yellowAccentColor,
                                text: AppStringsNew.restoreButtonText,
                                fontSize: 14.dp,
                                textColor: AppColorsNew.darkGreenShadeColor,
                                onTapFunction: () =>
                                    _handleRestoreClick(context),
                              ),
                            ],
                          ),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(24),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Text(
                              AppStringsNew.signupButtonText,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColorsNew.yellowAccentColor,
                              ),
                            ),
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
        Alerts.showNotification(
            titleText: AppStringsNew.restoreSuccessText);

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
