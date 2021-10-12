import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({Key key}) : super(key: key);

  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  List<AppThemeData> themeList = [
    AppThemeData(),
    AppThemeData(
      primaryColor: Colors.blueGrey.shade900,
      accentColor: Colors.amber[900],
      secondaryColor: Colors.blueGrey.shade400,
      fillInColor: Colors.grey.shade800,
      supportingColor: Colors.white,
    ),
    AppThemeData(
      primaryColor: Color(0xFF082032),
      accentColor: Color(0xFFFF4C29),
      secondaryColor: Colors.blueGrey,
      fillInColor: Color(0xFF2C394B),
      supportingColor: Color(0xFFEEEEEE),
    ),
    AppThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.amber[900],
      secondaryColor: Colors.blueGrey,
      fillInColor: Colors.grey,
      supportingColor: Colors.black,
    ),
    AppThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.amber[900],
      secondaryColor: Colors.blueGrey,
      fillInColor: Colors.grey,
      supportingColor: Colors.black,
    ),
    AppThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.amber[900],
      secondaryColor: Colors.blueGrey,
      fillInColor: Colors.grey,
      supportingColor: Colors.white70,
    ),
  ];

  // List<Color> colors = [
  //   Colors.amber,
  //   Colors.red,
  //   Colors.blue,
  //   Colors.greenAccent,
  //   Colors.blueGrey,
  //   Colors.purpleAccent,
  //   Colors.cyanAccent,
  //   Colors.deepOrange,
  //   Colors.teal,
  // ];

  // List<String> bgImageUrls = [
  //   "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/western%20saloon.jpeg",
  //   "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/bar_bookshelf.jpg",
  // ];
  // List<String> tableImageUrls = [
  //   "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/blue.png",
  //   "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/darkblue.png",
  //   "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/red.png",
  // ];
  AppThemeData selectedThemeData;
  String selectedBgUrl;
  String selectedTableUrl;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("customizeScreen");

    selectedThemeData = themeList[0];
    // selectedBgUrl = bgImageUrls[0];
    // selectedTableUrl = tableImageUrls[0];
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
                        // Text(
                        //   _appScreenText['appPrimaryColorWillBeAffected'],
                        //   style: AppDecorators.getSubtitle3Style(theme: theme),
                        // ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Container(
                          //   height: 56,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                AppDimensionsNew.getVerticalSizedBox(8),
                            itemCount: themeList.length,
                            shrinkWrap: true,
                            //scrollDirection: Axis.horizontal,
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

                                  theme.updateThemeData(selectedThemeData);
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
                            RoundedColorButton(
                              text: "Button",
                              onTapFunction: () {},
                            ),
                            RoundedColorButton(
                              text: "Button",
                              onTapFunction: () {},
                              backgroundColor: theme.accentColor,
                              textColor: theme.primaryColorWithDark(),
                            ),
                            RoundedColorButton(
                              text: "Button",
                              onTapFunction: () {},
                              backgroundColor: theme.primaryColor,
                              textColor: theme.secondaryColor,
                            ),
                            RoundedColorButton(
                              text: "Button",
                              onTapFunction: () {},
                              backgroundColor: Colors.transparent,
                              textColor: theme.secondaryColor,
                              borderColor: theme.primaryColor,
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

// // Game Background
//                   Container(
//                     decoration: AppDecorators.tileDecoration(theme),
//                     padding: EdgeInsets.all(16),
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _appScreenText['chooseBackground'],
//                           style: AppDecorators.getHeadLine4Style(theme: theme),
//                         ),
//                         Text(
//                           _appScreenText['gameScreenBackgroudnWillBeChanged'],
//                           style: AppDecorators.getSubtitle3Style(theme: theme),
//                         ),
//                         AppDimensionsNew.getVerticalSizedBox(8),
//                        /*  Container(
//                           height: 200,
//                           child: ListView.separated(
//                             separatorBuilder: (context, index) =>
//                                 AppDimensionsNew.getHorizontalSpace(8),
//                             itemCount: bgImageUrls.length,
//                             shrinkWrap: true,
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index) => InkResponse(
//                               onTap: () {
//                                 setState(() {
//                                   selectedBgUrl = bgImageUrls[index];
//                                 });
//                               },
//                               child: Container(
//                                 height: 180,
//                                 width: 180,
//                                 padding: EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: theme.accentColor,
//                                     width: selectedBgUrl == bgImageUrls[index]
//                                         ? 3
//                                         : 0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: CachedNetworkImage(
//                                   imageUrl: bgImageUrls[index],
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                    */    ],
//                     ),
//                   ),
/* 
// Table Background
                Container(
                  decoration: AppDecorators.tileDecoration(theme),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _appScreenText['chooseTable'],
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                      Text(
                        _appScreenText['tableImageOnGameScreenWillBeChanged'],
                        style: AppDecorators.getSubtitle3Style(theme: theme),
                      ),
                      AppDimensionsNew.getVerticalSizedBox(8),
                      Container(
                        height: 200,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              AppDimensionsNew.getHorizontalSpace(8),
                          itemCount: tableImageUrls.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => InkResponse(
                            onTap: () {
                              setState(() {
                                selectedTableUrl = tableImageUrls[index];
                              });
                            },
                            child: Container(
                              height: 180,
                              width: 180,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.accentColor,
                                  width: selectedTableUrl ==
                                          tableImageUrls[index]
                                      ? 3
                                      : 0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: tableImageUrls[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
               */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
