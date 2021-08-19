import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
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

  List<String> bgImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/western%20saloon.jpeg",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/bar_bookshelf.jpg",
  ];
  List<String> tableImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/blue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/darkblue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/red.png",
  ];
  AppThemeData selectedThemeData;
  String selectedBgUrl;
  String selectedTableUrl;

  @override
  void initState() {
    super.initState();
    selectedThemeData = themeList[0];
    selectedBgUrl = bgImageUrls[0];
    selectedTableUrl = tableImageUrls[0];
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
              titleText: AppStringsNew.customizeTitleText,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Colors Scheme
                  Container(
                    decoration: AppDecorators.tileDecoration(theme),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStringsNew.colorsTitleText,
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        Text(
                          AppStringsNew.colorsSubtitleText,
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        ),
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
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Text(
                                              "THEME ${index + 1}",
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
                                    AppDimensionsNew.getHorizontalSpace(16),
                                    Expanded(
                                      flex: 5,
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

// Game Background
                  Container(
                    decoration: AppDecorators.tileDecoration(theme),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStringsNew.bgImagesThemeText,
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        Text(
                          AppStringsNew.bgImagesSubtitleText,
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Container(
                          height: 200,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                AppDimensionsNew.getHorizontalSpace(8),
                            itemCount: bgImageUrls.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkResponse(
                              onTap: () {
                                setState(() {
                                  selectedBgUrl = bgImageUrls[index];
                                });
                              },
                              child: Container(
                                height: 180,
                                width: 180,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.accentColor,
                                    width: selectedBgUrl == bgImageUrls[index]
                                        ? 3
                                        : 0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: bgImageUrls[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

// Table Background
                  Container(
                    decoration: AppDecorators.tileDecoration(theme),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStringsNew.tableImagesThemeText,
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        Text(
                          AppStringsNew.tableImagesSubtitleText,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
