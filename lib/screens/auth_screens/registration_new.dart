import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/appname_logo.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';

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

                // Form
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Screen Name
                        TextFormField(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            focusedBorder: AppStylesNew.focusBorderStyle,
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
                                  AppStringsNew.screenNameHintToast,
                                  duration: Duration(seconds: 3),
                                );
                              },
                            ),
                            // hintText: "Screen Name",
                            // hintStyle: TextStyle(
                            //   color: Colors.,
                            // ),
                            errorBorder: AppStylesNew.errorBorderStyle,
                            labelText: AppStringsNew.screenNameLabelText,
                            labelStyle: AppStylesNew.labelTextFieldStyle,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: AppColorsNew.actionRowBgColor,
                            alignLabelWithHint: true,
                            border: AppStylesNew.borderStyle,
                          ),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // Name
                        TextFormField(
                          controller: _nameCtrl,
                          validator: (value) {
                            if (value.length > 30) {
                              return AppStringsNew.displayNameLengthErrorText;
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
                                  AppStringsNew.displayNameHintToast,
                                  duration: Duration(seconds: 4),
                                );
                              },
                            ),
                            errorBorder: AppStylesNew.errorBorderStyle,
                            //hintText: "Your Name (optional)",
                            labelText: AppStringsNew.displayNameLabelText,
                            filled: true,
                            fillColor: AppColorsNew.actionRowBgColor,
                            alignLabelWithHint: true,
                            border: AppStylesNew.borderStyle,
                          ),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(16),

                        // Recover Email
                        TextFormField(
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

                        // Terms and privacy text
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "By creating an account, you agree with our ",
                                  style: AppStylesNew.labelTextStyle.copyWith(
                                    fontSize: 10.dp,
                                  ),
                                ),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: AppStylesNew.labelTextStyle.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontSize: 10.dp,
                                  ),
                                  recognizer: _termsClick
                                    ..onTap = _openTermsOfService,
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: AppStylesNew.labelTextStyle.copyWith(
                                    fontSize: 10.dp,
                                  ),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: AppStylesNew.labelTextStyle.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontSize: 10.dp,
                                  ),
                                  recognizer: _privacyClick
                                    ..onTap = _openPrivacyPolicy,
                                ),
                              ],
                            ),
                          ),
                        ),
                        RoundedColorButton(
                          backgroundColor: AppColorsNew.yellowAccentColor,
                          text: AppStringsNew.signupButtonText,
                          fontSize: 14.dp,
                          textColor: AppColorsNew.darkGreenShadeColor,
                          onTapFunction: () => _handleSignUpClick(),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.restore_account);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      AppStringsNew.restoreAccountText,
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
      // Make API call for registration
      ConnectionDialog.show(
          context: context, loadingText: AppStringsNew.loadingTextRegister);
      bool status = await AuthService.register(
        AuthModel(
          authType: AuthType.Guest,
          name: _screenNameCtrl.text.trim(),
        ),
      );
      ConnectionDialog.dismiss(context: context);

      if (status) {
        Alerts.showNotification(
            titleText: AppStringsNew.registrationSuccessText);

        // Navigate to main screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.main,
          (_) => false,
        );
      } else
        Alerts.showNotification(titleText: AppStringsNew.registrationFailText);
    }
  }
}
