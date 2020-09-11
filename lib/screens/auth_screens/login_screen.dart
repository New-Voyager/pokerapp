import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/auth_screens/registration_screen.dart';
import 'package:pokerapp/screens/main_screens/main_screen.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_button.dart';

// TODO: LOGIN IS NOT FULLY FUNCTIONAL AS THERE IS NO API TO LOGIN
// TODO: THIS WILL BE CHANGED WHEN THERE WILL BE A LOGIN API IN FUTURE

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthModel _authModel = AuthModel();

  bool _showLoading = false;

  void _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  void _handleLogin(BuildContext ctx) async {
    _toggleLoading();

    bool status = await AuthService.register(_authModel);

    if (!status)
      return Alerts.showSnackBar(
        ctx,
        'Wrong credentials',
      );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final separator30 = SizedBox(height: 30.0);
    final separator20 = SizedBox(height: 20.0);
    final separator5 = SizedBox(height: 5.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (ctx) => SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: _showLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 23.0,
                vertical: 28.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // welcome text
                  Text(
                    AppStrings.welcomeText,
                    textAlign: TextAlign.left,
                    style: AppStyles.welcomeTextStyle,
                  ),
                  separator30,

                  // user name field with label
                  Text(
                    AppStrings.usernameText,
                    style: AppStyles.credentialsTextStyle,
                  ),
                  separator5,
                  CardFormTextField(
                    hintText: AppStrings.usernameText,
                    onChanged: (String newValue) =>
                        _authModel.name = newValue.trim(),
                  ),
                  separator20,

                  // password field with label
                  Text(
                    AppStrings.passwordText,
                    style: AppStyles.credentialsTextStyle,
                  ),
                  separator5,
                  CardFormTextField(
                    hintText: AppStrings.passwordText,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (String newValue) =>
                        _authModel.password = newValue.trim(),
                  ),

                  separator30,
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrationScreen(),
                      ),
                    ),
                    child: Text(
                      AppStrings.registerNowText,
                      textAlign: TextAlign.end,
                      style: AppStyles.clubItemInfoTextStyle.copyWith(
                        fontSize: 18.0,
                        // TODO PUT ALL STYLES IN SEPARATE MODULE
                      ),
                    ),
                  ),

                  Spacer(),

                  RoundRaisedButton(
                    buttonText: 'LOGIN',
                    radius: 100.0,
                    color: Color(0xff319ffe),
                    verticalPadding: 15.0,
                    onButtonTap: () => _handleLogin(ctx),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
