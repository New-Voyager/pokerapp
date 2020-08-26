import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_button.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthModel _authModel = AuthModel();

  bool _showLoading = false;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  // move user to the dashboard
  _move() {}

  _register(BuildContext ctx) async {
    // validate : user name must not be empty
    // validate: email must be a non empty and valid
    // validate: password must not be empty
    if (_authModel.name == null || _authModel.name.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a display name",
      );

    // todo: also use a regular expression to validate the email
    if (_authModel.email == null || _authModel.email.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide an email",
      );

    if (_authModel.password == null || _authModel.email.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a password",
      );

    _toggleLoading();

    bool status = await AuthService.register(_authModel);

    _toggleLoading();

    if (status)
      Alerts.showSnackBar(ctx, 'Registered successfully');
    else
      Alerts.showSnackBar(ctx, 'Something went wrong');

    _move();
  }

  _registerAsGuest(BuildContext ctx) async {
    // validate : user name must not be empty

    if (_authModel.name == null || _authModel.name.isEmpty)
      return Alerts.showSnackBar(
        ctx,
        "You must provide a display name",
      );

    _toggleLoading();

    bool status = await AuthService.register(_authModel);

    _toggleLoading();

    if (status)
      Alerts.showSnackBar(ctx, 'Registered as guest');
    else
      Alerts.showSnackBar(ctx, 'Something went wrong');

    _move();
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
