import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/build_info.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/profile_screens/report_bug.dart';
import 'package:pokerapp/screens/profile_screens/request_feature.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/custom_divider.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatelessWidget {
  final version;
  const HelpScreen({Key key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTextScreen _appScreenText = getAppTextScreen("profilePageNew");

    final size = MediaQuery.of(context).size;
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                theme: theme,
                context: context,
                titleText: _appScreenText['appName'],
                subTitleText: version,
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                      child: Image.asset(
                        AppAssetsNew.logoImage,
                        height: size.height / 5,
                        width: size.height / 5,
                      ),
                    ),
                    Container(
                      decoration: AppDecorators.tileDecoration(theme),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              _appScreenText['requestFeature'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            leading: Icon(
                              Icons.request_page,
                              color: theme.secondaryColor,
                            ),
                            onTap: () {
                              Alerts.showDailog(
                                context: context,
                                child: RequestFeatureWidget(),
                              );
                            },
                          ),
                          CustomDivider(),
                          ListTile(
                            title: Text(
                              _appScreenText['reportBug'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            leading: Icon(
                              Icons.request_page,
                              color: theme.secondaryColor,
                            ),
                            onTap: () {
                              Alerts.showDailog(
                                context: context,
                                child: ReportBugWidget(),
                              );
                            },
                          ),
                          CustomDivider(),
                          ListTile(
                            title: Text(
                              _appScreenText['policy'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            leading: Icon(
                              Icons.help_center,
                              color: theme.secondaryColor,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.privacy_policy);
                            },
                          ),
                          CustomDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.privacy_tip,
                              color: theme.secondaryColor,
                            ),
                            title: Text(
                              _appScreenText['toc'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.terms_conditions,
                              );
                            },
                          ),
                          CustomDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.copyright,
                              color: theme.secondaryColor,
                            ),
                            title: Text(
                              _appScreenText['attributions'],
                              style:
                                  AppDecorators.getHeadLine4Style(theme: theme),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.attributions,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ...getSystemInfo(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> getSystemInfo() {
    return [
      Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Text('Size: ${Screen.diagonalInches.toStringAsPrecision(2)}')),
      Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Text('model: ${DeviceInfo.model}')),
      Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Text('version: ${DeviceInfo.version}')),
      AppDimensionsNew.getVerticalSizedBox(80.ph),
    ];
  }
}
