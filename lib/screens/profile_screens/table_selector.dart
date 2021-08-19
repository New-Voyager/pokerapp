import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class TableSelectorScreen extends StatefulWidget {
  TableSelectorScreen({Key key}) : super(key: key);

  @override
  _TableSelectorScreenState createState() => _TableSelectorScreenState();
}

class _TableSelectorScreenState extends State<TableSelectorScreen>
    with SingleTickerProviderStateMixin {
  List<String> tableImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/blue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/darkblue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table/red.png",
  ];
  List<String> bgImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/western%20saloon.jpeg",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/bar_bookshelf.jpg",
  ];
  TabController _tabController;
  int selectedTable = 0, selectedDrop = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    /* get the screen sizes, and initialize the board attributes */
    BoardAttributesObject boardAttributes = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );
    double tableScale = boardAttributes.tableScale;
    final boardDimensions = BoardView.dimensions(context, true);

    return Consumer<AppTheme>(builder: (_, theme, __) {
      return Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: BackArrowWidget(),
            backgroundColor: theme.primaryColorWithDark().withAlpha(150),
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              CachedNetworkImage(
                imageUrl: bgImageUrls[selectedDrop],
              ),
              /* main view */
              Column(
                children: [
                  // main board view
                  _buildBoardView(boardDimensions, tableScale, size),

                  /* divider that divides the board view and the footer */
                  Divider(color: AppColorsNew.dividerColor, thickness: 3),

                  // footer section
                  Expanded(
                    child: _buildFooterView(theme, size),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  _buildBoardView(Size boardDimensions, double tableScale, Size size) {
    return Container(
      height: size.height * 0.6,
      width: boardDimensions.width,
      padding: EdgeInsets.only(top: 100),
      child: Transform.scale(
        scale: tableScale,
        child: CachedNetworkImage(
          imageUrl: tableImageUrls[selectedTable],
          fit: BoxFit.scaleDown,
          width: size.width,
        ),
      ),
    );
  }

  _buildFooterView(AppTheme theme, Size size) {
    return Container(
      //height: size.height * 0.4,
      padding: EdgeInsets.only(top: 16),
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Column(
        children: [
          TabBar(
            tabs: [
              Text(
                "Table",
              ),
              Text(
                "Backdrop",
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.accentColor,
            labelStyle: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                //height: size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: () {
                        setState(() {
                          selectedTable = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: size.height * 0.1,
                        width: size.height * 0.2,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: (selectedTable == index)
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: tableImageUrls[index],
                            ),
                            Visibility(
                              visible: (selectedTable == index),
                              child: Icon(Icons.done),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      AppDimensionsNew.getHorizontalSpace(16),
                  itemCount: tableImageUrls.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                //height: size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: () {
                        setState(() {
                          selectedDrop = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: size.height * 0.1,
                        width: size.height * 0.2,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: (selectedDrop == index)
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: bgImageUrls[index],
                            ),
                            Visibility(
                              visible: (selectedDrop == index),
                              child: Icon(Icons.done),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      AppDimensionsNew.getHorizontalSpace(16),
                  itemCount: bgImageUrls.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
