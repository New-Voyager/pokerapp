import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:provider/provider.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({Key key}) : super(key: key);

  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  List<Color> colors = [
    Colors.amber,
    Colors.red,
    Colors.blue,
    Colors.greenAccent,
    Colors.blueGrey,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.deepOrange,
    Colors.teal,
  ];

  List<String> bgImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/western-saloon.jpg",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/bar_bookshelf.jpg",
  ];
  List<String> tableImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/blue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/darkblue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/red.png",
  ];
  Color selectedColor;
  String selectedBgUrl;
  String selectedTableUrl;

  @override
  void initState() {
    super.initState();
    selectedColor = colors[0];
    selectedBgUrl = bgImageUrls[0];
    selectedTableUrl = tableImageUrls[0];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppStylesNew.BgGreenRadialGradient,
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
                    decoration: AppStylesNew.actionRowDecoration,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStringsNew.colorsTitleText),
                        Text(
                          AppStringsNew.colorsSubtitleText,
                          style: AppStylesNew.labelTextStyle,
                        ),
                        AppDimensionsNew.getVerticalSizedBox(8),
                        Container(
                          height: 56,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                AppDimensionsNew.getHorizontalSpace(8),
                            itemCount: colors.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkResponse(
                              onTap: () {
                                setState(() {
                                  selectedColor = colors[index];
                                });
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: colors[index],
                                child: selectedColor == colors[index]
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

// Game Background
                  Container(
                    decoration: AppStylesNew.actionRowDecoration,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStringsNew.bgImagesThemeText),
                        Text(
                          AppStringsNew.bgImagesSubtitleText,
                          style: AppStylesNew.labelTextStyle,
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
                                    color: AppColorsNew.newBorderColor,
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
                    decoration: AppStylesNew.actionRowDecoration,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStringsNew.tableImagesThemeText),
                        Text(
                          AppStringsNew.tableImagesSubtitleText,
                          style: AppStylesNew.labelTextStyle,
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
                                    color: AppColorsNew.newBorderColor,
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
