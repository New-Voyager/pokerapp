import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_host_urls.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/auth_screens/registration_screen.dart';
import 'package:pokerapp/screens/main_screens/main_screen.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String nats;
  String apiServer;

  void setUrls(BuildContext ctx) async {
    if ((nats == null || nats.isEmpty) ||
        (apiServer == null || apiServer.isEmpty))
      return Alerts.showSnackBar(ctx, 'Nats and API urls are needed');

    // FIRST SET THE URLS
    await AppHostUrls.save(
      nats: nats,
      apiServer: apiServer,
    );

    await graphQLConfiguration.init();

    if (mounted) setState(() {});

    Alerts.showSnackBar(ctx, 'Nats and API urls SET');
  }

  Widget _buildHostUrlWidget(BuildContext ctx) => Column(
        children: [
          CardFormTextField(
            hintText: 'API SERVER ($apiServer)',
            keyboardType: TextInputType.text,
            onChanged: (String newValue) => apiServer = newValue.trim(),
          ),
          const SizedBox(height: 10),
          CardFormTextField(
            hintText: 'NATS SERVER ($nats)',
            keyboardType: TextInputType.text,
            onChanged: (String newValue) => nats = newValue.trim(),
          ),
          const SizedBox(height: 10),
          RoundRaisedButton(
            buttonText: 'SET',
            radius: 100.0,
            color: Color(0xff319ffe),
            verticalPadding: 15.0,
            onButtonTap: () => setUrls(ctx),
          ),
        ],
      );

  AuthModel _authModel = AuthModel(authType: AuthType.Email);

  bool _showLoading = false;

  void _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  void _handleLogin(BuildContext ctx) async {
    _toggleLoading();

    Map<String, dynamic> s = await AuthService.login(_authModel);

    bool status = s['status'];
    String message = s['message'];

    _toggleLoading();

    if (!status)
      return Alerts.showSnackBar(
        ctx,
        message,
      );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(),
      ),
    );
  }

  void fetchUrls() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    nats = sharedPreferences.getString(AppConstants.NATS_URL);
    apiServer = sharedPreferences.getString(AppConstants.API_SERVER_URL);

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetchUrls();
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
              child: ListView(
                physics: BouncingScrollPhysics(),
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
                    AppStrings.emailText,
                    style: AppStyles.credentialsTextStyle,
                  ),
                  separator5,
                  CardFormTextField(
                    hintText: AppStrings.emailText,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String newValue) =>
                        _authModel.email = newValue.trim(),
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

                  separator30,

                  _buildHostUrlWidget(ctx),

                  _buildTempLogin(),

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

  _loginWithUsername(BuildContext context) {
    String username = Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value;

    _authModel.authType = AuthType.Name;
    _authModel.name = username;

    _handleLogin(context);
  }

  Widget _buildTempLogin() => ListenableProvider<ValueNotifier<String>>(
        create: (_) => ValueNotifier<String>(''),
        builder: (context, _) => Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (String s) => Provider.of<ValueNotifier<String>>(
                    context,
                    listen: false,
                  ).value = s,
                ),
              ),
              const SizedBox(width: 50.0),
              InkWell(
                onTap: () => _loginWithUsername(context),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
