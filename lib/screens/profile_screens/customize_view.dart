import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/models/ui/app_theme_styles.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({Key key}) : super(key: key);

  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  List<AppThemeStyle> themeList = [
    // AppThemeData(
    //   roundedButtonBackgroundColor: Color(0xFFD89E40),
    //   roundedButton2BackgroundColor: Color(0xFF033614),
    //   confirmYesButtonBackgroundColor: Colors.purple,
    //   roundedButtonTextStyle: AppStylesNew.joinTextStyle.copyWith(
    //     color: Colors.black,
    //     fontWeight: FontWeight.normal,
    //     fontSize: 10.dp,
    //   ),
    // ),
    // AppThemeData(
    //   primaryColor: Colors.blueGrey.shade900,
    //   accentColor: Colors.amber[900],
    //   secondaryColor: Colors.blueGrey.shade400,
    //   fillInColor: Colors.grey.shade800,
    //   supportingColor: Colors.white,
    // ),
    // AppThemeData(
    //   primaryColor: Color(0xFF082032),
    //   accentColor: Color(0xFFFF4C29),
    //   secondaryColor: Colors.blueGrey,
    //   fillInColor: Color(0xFF2C394B),
    //   supportingColor: Color(0xFFEEEEEE),
    // ),
    // AppThemeData(
    //   primaryColor: Colors.blue,
    //   accentColor: Colors.amber[900],
    //   secondaryColor: Colors.blueGrey,
    //   fillInColor: Colors.grey,
    //   supportingColor: Colors.black,
    //   roundedButtonBackgroundColor: Colors.blueGrey,
    //   roundedButton2BackgroundColor: Colors.purple,
    //   confirmYesButtonBackgroundColor: Colors.purple,
    // ),
    // AppThemeData(
    //   primaryColor: Colors.blue,
    //   accentColor: Colors.amber[900],
    //   secondaryColor: Colors.blueGrey,
    //   fillInColor: Colors.grey,
    //   supportingColor: Colors.white70,
    // ),
    // AppThemeData(
    //   primaryColor: Color(0xFFA2D2FF),
    //   accentColor: Color(0xFFD2EB38),
    //   secondaryColor: Color(0xFFFFFFFF),
    //   fillInColor: Color(0xFFDFF4FE),
    //   supportingColor: Color(0xFFF9FDFE),
    //   navFabColor: Colors.purple,
    // ),
  ];

  AppThemeStyle selectedThemeData;
  String selectedBgUrl;
  String selectedTableUrl;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("customizeScreen");

    selectedThemeData = themeList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              theme: theme,
              context: context,
              titleText: _appScreenText['customize'],
            ),
            body: Column(
              children: [
                // Colors Scheme
                Expanded(
                  child: Container(
                    decoration: AppDecorators.tileDecoration(theme),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _appScreenText['chooseColor'],
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Container(
                          //   height: 56,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                AppDimensionsNew.getVerticalSizedBox(8),
                            itemCount: themeList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final themeData = themeList[index];

                              final int savedIndex = HiveDatasource.getInstance
                                      .getBox(BoxType.USER_SETTINGS_BOX)
                                      .get("themeIndex") ??
                                  0;
                              return InkResponse(
                                onTap: () async {
                                  setState(() {
                                    selectedThemeData = themeList[index];
                                  });
                                  final settings = HiveDatasource.getInstance
                                      .getBox(BoxType.USER_SETTINGS_BOX);
                                  settings.put(
                                      'theme', themeList[index].toMap());
                                  settings.put('themeIndex', index);

                                  // theme.updateThemeData(selectedThemeData);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${_appScreenText['theme']} ${index + 1}",
                                              style: AppDecorators
                                                  .getSubtitle1Style(
                                                      theme: theme),
                                            ),
                                            Visibility(
                                              child: Icon(
                                                Icons.done,
                                                color: theme.accentColor,
                                              ),
                                              visible: index == savedIndex,
                                            ),
                                          ],
                                        )),
                                    AppDimensionsNew.getHorizontalSpace(8),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration:
                                            AppDecorators.tileDecoration(theme)
                                                .copyWith(
                                                    border: Border.all(
                                                        color: Colors.white)),
                                        height: 32,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData.primaryColor,
                                            ),
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData.secondaryColor,
                                            ),
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData.accentColor,
                                            ),
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData.fillInColor,
                                            ),
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData.supportingColor,
                                            ),
                                            Container(
                                              height: 32,
                                              width: 32,
                                              color: themeData
                                                  .negativeOrErrorColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppDimensionsNew.getVerticalSizedBox(32),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 32,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            RoundRectButton(
                              text: "Button",
                              onTap: () {},
                              theme: theme,
                            ),
                            RoundRectButton2(
                              text: "Button",
                              onTap: () {},
                              theme: theme,
                            ),
                            CircleImageButton(
                              onTap: () {},
                              theme: theme,
                              asset: "assets/images/record.png",
                            ),
                            CircleImageButton(
                              onTap: () {},
                              theme: theme,
                              svgAsset: "assets/images/lasthand.svg",
                            ),
                            CircleImageButton(
                              onTap: () {},
                              theme: theme,
                              icon: Icons.info_outline_rounded,
                            ),
                            ConfirmYesButton(
                              onTap: () {},
                              theme: theme,
                            ),
                            ConfirmNoButton(
                              onTap: () {},
                              theme: theme,
                            ),
                          ],
                          runSpacing: 32,
                        ),
                        Text(
                          "Heading1",
                          style: AppDecorators.getHeadLine1Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Text(
                          "Heading2",
                          style: AppDecorators.getHeadLine2Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        Text(
                          "Heading3",
                          style: AppDecorators.getHeadLine3Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        Text(
                          "Heading4",
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        Text(
                          "Heading5",
                          style: AppDecorators.getHeadLine5Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        Text(
                          "Heading6",
                          style: AppDecorators.getHeadLine6Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Text(
                          "Subtitle1",
                          style: AppDecorators.getSubtitle1Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Text(
                          "Subtitle2",
                          style: AppDecorators.getSubtitle2Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Text(
                          "Subtitle3",
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),

                        // Text(
                        //   _appScreenText['appPrimaryColorWillBeAffected'],
                        //   style: AppDecorators.getSubtitle3Style(theme: theme),
                        // ),
                      ],
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
}
