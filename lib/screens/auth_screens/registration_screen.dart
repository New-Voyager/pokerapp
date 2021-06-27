import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with RouteAwareAnalytics{

  @override
  String get routeName => Routes.registration;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthModel _authModel = AuthModel();

  bool _showLoading = false;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  // move user to the main screen
  _move() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.main,
      (_) => false,
    );
  }

  _register(BuildContext ctx) async {
    // validate : user name must not be empty
    // validate: email must be a non empty and valid
    // validate: password must not be empty
    if (_authModel.name == null || _authModel.name.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a display name",
      );

    if (_authModel.email == null || _authModel.email.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide an email",
      );

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_authModel.email.trim()))
      return Alerts.showSnackBar(ctx, 'Enter a valid email');

    if (_authModel.password == null || _authModel.email.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a password",
      );

    /* set the auth type as email registration */
    _authModel.authType = AuthType.Email;

    _toggleLoading();

    bool status = await AuthService.register(_authModel);

    _toggleLoading();

    if (status) {
      Alerts.showSnackBar(ctx, 'Registered successfully');
      _move();
    } else
      Alerts.showSnackBar(ctx, 'Something went wrong');
  }

  _registerAsGuest(BuildContext ctx) async {
    // validate : user name must not be empty

    if (_authModel.name == null || _authModel.name.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a display name",
      );

    /* set the auth type as guest registration */
    _authModel.authType = AuthType.Guest;

    _toggleLoading();

    bool status = await AuthService.register(_authModel);

    _toggleLoading();

    if (status) {
      Alerts.showSnackBar(ctx, 'Registered as guest');
      _move();
    } else
      Alerts.showSnackBar(ctx, 'Something went wrong');
  }

  @override
  Widget build(BuildContext context) {
    final separator30 = SizedBox(height: 30.0);
    final separator20 = SizedBox(height: 20.0);
    final separator5 = SizedBox(height: 5.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: _showLoading,
        child: Builder(
          builder: (ctx) => SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 23.0, vertical: 28.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    // welcome text
                    Text(
                      'Register',
                      textAlign: TextAlign.left,
                      style: AppStyles.welcomeTextStyle,
                    ),
                    separator30,

                    // user name field with label
                    Text(
                      'Display Name',
                      style: AppStyles.credentialsTextStyle,
                    ),
                    separator5,
                    CardFormTextField(
                      hintText: 'Display Name',
                      onChanged: (String newVal) =>
                          _authModel.name = newVal.trim(),
                    ),
                    separator20,

                    // user name field with label
                    Text(
                      'Email',
                      style: AppStyles.credentialsTextStyle,
                    ),
                    separator5,
                    CardFormTextField(
                      hintText: 'Email',
                      onChanged: (String newVal) =>
                          _authModel.email = newVal.trim(),
                    ),
                    separator20,

                    // password field with label
                    Text(
                      AppStrings.passwordText,
                      style: AppStyles.credentialsTextStyle,
                    ),
                    separator5,
                    CardFormTextField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      hintText: AppStrings.passwordText,
                      onChanged: (String newVal) =>
                          _authModel.password = newVal.trim(),
                    ),

                    separator30,
                    RoundRaisedButton(
                      buttonText: 'REGISTER',
                      radius: 100.0,
                      color: Color(0xff319ffe),
                      verticalPadding: 15.0,
                      onButtonTap: () => _register(ctx),
                    ),

                    /* or login as guest */
                    separator30,
                    Text(
                      'Or',
                      textAlign: TextAlign.center,
                      style: AppStyles.credentialsTextStyle,
                    ),

                    separator30,
                    RoundRaisedButton(
                      buttonText: 'REGISTER AS GUEST',
                      radius: 100.0,
                      color: Color(0xff319ffe),
                      verticalPadding: 15.0,
                      onButtonTap: () => _registerAsGuest(ctx),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
