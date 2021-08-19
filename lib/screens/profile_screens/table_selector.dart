import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
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
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table-1/blue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table-1/darkblue.png",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/table-1/red.png",
  ];
  List<String> bgImageUrls = [
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/western%20saloon.jpeg",
    "https://assets-pokerclubapp.nyc3.digitaloceanspaces.com/background/bar_bookshelf.jpg",
  ];
  TabController _tabController;
  int selectedTable = 0, selectedDrop = 0;
  List<Asset> _tableAssets = [];
  List<Asset> _backDropAssets = [];
  Asset _selectedTable, _selectedDrop;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchSavedItems();
    });

    super.initState();
  }

  void _fetchSavedItems() async {
    AssetService.assets.forEach((element) {
      if (element.type == "game-background") {
        _backDropAssets.add(element);
      } else if (element.type == "table") {
        _tableAssets.add(element);
      }
    });
    _selectedTable = await AssetService.getDefaultTableAsset();
    _selectedDrop = await AssetService.getDefaultBackdropAsset();
    setState(() {});
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

    return Consumer<AppTheme>(
      builder: (_, theme, __) {
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
                _selectedDrop?.downloadedPath == null ||
                        _selectedDrop.downloadedPath.isEmpty
                    ? CircularProgressWidget(text: "Downloading...")
                    : Image.file(
                        File(_selectedDrop?.downloadedPath),
                        fit: BoxFit.scaleDown,
                        width: size.width,
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
      },
    );
  }

  _buildBoardView(Size boardDimensions, double tableScale, Size size) {
    return Container(
      height: size.height * 0.5,
      width: boardDimensions.width,
      padding: EdgeInsets.only(top: 100),
      child: Transform.scale(
        scale: tableScale,
        child: _selectedTable?.downloadedPath == null ||
                _selectedTable.downloadedPath.isEmpty
            ? CircularProgressWidget(text: "Downloading...")
            : Image.file(
                File(_selectedTable?.downloadedPath),
                //   fit: BoxFit.scaleDown,
                width: boardDimensions.width,
                height: boardDimensions.height,
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
                    final bool isSelected =
                        (_selectedTable?.id == _tableAssets[index].id);
                    return InkResponse(
                      onTap: () async {
                        // _selectedTable = _tableAssets[index];

                        setState(() {
                          _selectedTable = _tableAssets[index];
                        });

                        if (!_selectedTable.downloaded) {
                          log("Downloading ${_selectedTable.id} : ${_selectedTable.name}");
                          _tableAssets[index] =
                              await AssetService.saveFile(_tableAssets[index]);
                          await AssetService.hiveStore.put(_tableAssets[index]);
                        }
                        await AssetService.setDefaultTableAsset(
                            asset: _tableAssets[index]);
                        setState(() {});
                        final asset = await AssetService.getDefaultTableAsset();
                        log(jsonEncode(asset.toJson()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: size.height * 0.1,
                        width: size.height * 0.2,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: _tableAssets[index].previewLink,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(Icons.done),
                            ),
                            Visibility(
                              visible:
                                  !(_tableAssets[index].downloaded ?? true),
                              child: Container(
                                height: size.height * 0.1,
                                width: size.height * 0.2,
                                color: Colors.black.withOpacity(0.5),
                                child: Icon(Icons.download_for_offline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      AppDimensionsNew.getHorizontalSpace(16),
                  itemCount: _tableAssets.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                //height: size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        (_selectedDrop?.id == _backDropAssets[index].id);
                    return InkResponse(
                      onTap: () async {
                        // _selectedTable = _tableAssets[index];

                        setState(() {
                          _selectedDrop = _backDropAssets[index];
                        });

                        if (!_selectedDrop.downloaded) {
                          log("Downloading ${_selectedDrop.id} : ${_selectedDrop.name}");
                          _backDropAssets[index] = await AssetService.saveFile(
                              _backDropAssets[index]);
                          AssetService.hiveStore.put(_backDropAssets[index]);
                          AssetService.setDefaultTableAsset(
                              asset: _backDropAssets[index]);
                          setState(() {});
                        }
                        AssetService.setDefaultBackdropAsset(
                            asset: _backDropAssets[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: size.height * 0.1,
                        width: size.height * 0.2,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: _backDropAssets[index].previewLink,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(Icons.done),
                            ),
                            Visibility(
                              visible:
                                  !(_backDropAssets[index].downloaded ?? true),
                              child: Container(
                                height: size.height * 0.1,
                                width: size.height * 0.2,
                                color: Colors.black.withOpacity(0.5),
                                child: Icon(Icons.download_for_offline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      AppDimensionsNew.getHorizontalSpace(16),
                  itemCount: _backDropAssets.length,
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
