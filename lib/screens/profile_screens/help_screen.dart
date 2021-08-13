import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatelessWidget {
  final version;
  const HelpScreen({Key key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                titleText: AppStringsNew.appName,
                subTitleText: version,
              ),
              body: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: SvgPicture.asset(
                      AppAssetsNew.resumeImagePath,
                      height: size.height / 3,
                      width: size.width,
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
                            AppStringsNew.helpCenterText,
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          leading: Icon(
                            Icons.help_center,
                            color: theme.secondaryColor,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(
                            AppStringsNew.requestFeature,
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          leading: Icon(
                            Icons.request_page,
                            color: theme.secondaryColor,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip,
                            color: theme.secondaryColor,
                          ),
                          title: Text(
                            AppStringsNew.termsPolicy,
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.copyright,
                            color: theme.secondaryColor,
                          ),
                          title: Text(
                            AppStringsNew.licenses,
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
