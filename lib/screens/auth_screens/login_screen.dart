import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/auth_screens/registration_screen.dart';
import 'package:pokerapp/screens/main_screens/main_screen.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _handleLogin() {
    // todo this function handles the login

    // todo dev -- remove this
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 28.0),
          child: Form(
            key: _formKey,
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
                  onButtonTap: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
