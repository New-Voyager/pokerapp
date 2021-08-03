import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';

class HelpScreen extends StatelessWidget {
  final version;
  const HelpScreen({Key key, this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
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
                decoration: AppStylesNew.blackContainerDecoration,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(AppStringsNew.helpCenterText),
                      leading: Icon(Icons.help_center),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(AppStringsNew.requestFeature),
                      leading: Icon(Icons.request_page),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip),
                      title: Text(AppStringsNew.termsPolicy),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.copyright),
                      title: Text(AppStringsNew.licenses),
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
  }
}
