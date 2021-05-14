import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_host_urls.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String apiServer;

  void setUrls(BuildContext ctx) async {
    if ((apiServer == null || apiServer.isEmpty))
      return Alerts.showSnackBar(ctx, 'API url is needed');

    // FIRST SET THE URLS
    await AppHostUrls.save(
      apiServer: apiServer,
    );

    await graphQLConfiguration.init();

    if (mounted) setState(() {});

    Alerts.showSnackBar(ctx, 'API url is SET');
  }

  Widget _buildHostUrlWidget(BuildContext ctx) => Column(
        children: [
          CardFormTextField(
            hintText: 'API SERVER ($apiServer)',
            keyboardType: TextInputType.text,
            onChanged: (String newValue) => apiServer = newValue.trim(),
          ),
          const SizedBox(height: 10),
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

    if (TestService.isTesting) {
      // let the user login
    } else {
      Map<String, dynamic> s = await AuthService.login(_authModel);

      bool status = s['status'];
      String message = s['message'];

      _toggleLoading();

      if (!status)
        return Alerts.showSnackBar(
          ctx,
          message,
        );
    }

    Navigator.pushReplacementNamed(
      context,
      Routes.main,
    );
  }

  void fetchUrls() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    apiServer = sharedPreferences.getString(AppConstants.API_SERVER_URL);

    if (apiServer == null) {
      apiServer = AppConstants.DO_API_URL;
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetchUrls();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final separator30 = SizedBox(height: height * 0.03);
    final separator20 = SizedBox(height: height * 0.05);
    final separator5 = SizedBox(height: height * 0.01);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (ctx) => SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: _showLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.029,
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
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.registration,
                    ),
                    child: Text(
                      AppStrings.registerNowText,
                      textAlign: TextAlign.end,
                      style: AppStyles.clubItemInfoTextStyle.copyWith(
                        fontSize: height * 0.025,
                        // TODO PUT ALL STYLES IN SEPARATE MODULE
                      ),
                    ),
                  ),

                  separator30,

                  !AppConstants.PROD_MODE
                      ? _buildHostUrlWidget(ctx)
                      : SizedBox(
                          height: 0,
                        ),

                  !AppConstants.PROD_MODE
                      ? _buildTempLogin()
                      : SizedBox(
                          height: 0,
                        ),

                  RoundRaisedButton(
                    buttonText: 'LOGIN',
                    radius: 100.0,
                    color: Color(0xff319ffe),
                    verticalPadding: height * 0.019,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
      builder: (context, _) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.04),
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.01,
            vertical: height * 0.01,
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
              SizedBox(width: width * 0.05),
              InkWell(
                onTap: () => _loginWithUsername(context),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
