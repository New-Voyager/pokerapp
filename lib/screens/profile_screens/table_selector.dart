import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/nameplate_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/app/user_settings_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/user_settings.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class TableSelectorScreen extends StatefulWidget {
  TableSelectorScreen({Key key}) : super(key: key);

  @override
  _TableSelectorScreenState createState() => _TableSelectorScreenState();
}

class _TableSelectorScreenState extends State<TableSelectorScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int selectedTable = 0, selectedDrop = 0;
  List<Asset> _tableAssets = [];
  List<Asset> _backDropAssets = [];
  List<NamePlateDesign> _nameplateAssets = [];
  Asset _selectedTable, _selectedDrop;
  NamePlateDesign _selectedNamePlate;
  var customizeService = CustomizationService();

  bool initialized = false;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchSavedItems();
    });

    initialized = true;
    super.initState();
  }

  void _fetchSavedItems() async {
    await AssetService.refresh();
    await customizeService.load();

    _backDropAssets = AssetService.getBackdrops();
    _tableAssets = AssetService.getTables();
    _nameplateAssets = AssetService.getNameplates();

    // Get Asset for selectedTableId
    _selectedTable =
        AssetService.getAssetForId(UserSettingsService.getSelectedTableId());
    // if the asset is not found in hive request for default asset.
    if (_selectedTable == null) {
      _selectedTable =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_TABLE);
      //  _tableAssets.add(_selectedTable);
    }

    // Get Asset for selected drop
    _selectedDrop =
        AssetService.getAssetForId(UserSettingsService.getSelectedBackdropId());
    // if the asset is not found in hive request for default asset.
    if (_selectedDrop == null) {
      _selectedDrop =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_BACKDROP);
      // _backDropAssets.add(_selectedDrop);
    }

    // Get Asset for selected nameplate
    _selectedNamePlate = AssetService.getNameplateForId(
        UserSettingsService.getSelectedNameplateId());
    // if the asset is not found in hive request for default asset.
    if (_selectedNamePlate == null) {
      _selectedNamePlate = AssetService.getNameplateForId(
          UserSettingsStore.VALUE_DEFAULT_NAMEPLATE);
    }

    setState(() {});
  }

  Widget _buildTopView(AppTheme theme) {
    var gameCode = 'CUSTOMIZE';
    return GamePlayScreen(
      gameCode: gameCode,
      customizationService: customizeService,
      showTop: true,
      showBottom: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // /* get the screen sizes, and initialize the board attributes */
    // BoardAttributesObject boardAttributes = BoardAttributesObject(
    //   screenSize: Screen.diagonalInches,
    // );

    // double tableScale = boardAttributes.tableScale;
    // final boardDimensions = BoardView.dimensions(context, true);

    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        final boardView = _buildTopView(theme);
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                // main board view
                //_buildBoardView(boardDimensions, tableScale, size),
                Container(
                  width: Screen.width,
                  height: 2 * Screen.height / 3,
                  child: boardView,
                ),

                /* divider that divides the board view and the footer */
                // Divider(color: AppColorsNew.dividerColor, thickness: 3),

                // footer section
                Expanded(
                  child: _buildFooterView(theme, size),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _buildBoardView(Size boardDimensions, double tableScale, Size size) {
  //   Widget table = CircularProgressWidget();
  //   if (initialized) {
  //     if (_selectedTable != null) {
  //       if (_selectedTable.bundled ?? false) {
  //         table = Image.asset(
  //           _selectedTable?.downloadedPath,
  //           //   fit: BoxFit.scaleDown,
  //           width: boardDimensions.width,
  //           height: boardDimensions.height,
  //         );
  //       } else {
  //         if (!_selectedTable.downloaded) {
  //           table = CircularProgressWidget(text: "Downloading...");
  //         } else {
  //           table = Image.file(
  //             File(_selectedTable?.downloadedPath),
  //             //   fit: BoxFit.scaleDown,
  //             width: boardDimensions.width,
  //             height: boardDimensions.height,
  //           );
  //         }
  //       }
  //     }
  //   } else {
  //     table = CircularProgressWidget(text: "Downloading...");
  //   }
  //   return Container(
  //     height: size.height * 0.5,
  //     width: boardDimensions.width,
  //     padding: EdgeInsets.only(top: 100),
  //     child: Transform.scale(
  //       scale: tableScale,
  //       child: table,
  //     ),
  //   );
  // }

  _buildFooterView(AppTheme theme, Size size) {
    return Container(
      //height: size.height * 0.4,
      padding: EdgeInsets.only(top: 16),
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Column(
        children: [
          TabBar(
            physics: const BouncingScrollPhysics(),
            tabs: [
              Text(
                "Table",
              ),
              Text(
                "Backdrop",
              ),
              Text(
                "Nameplate",
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.accentColor,
            labelStyle: AppDecorators.getHeadLine4Style(theme: theme),
          ),
          FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 100)),
            builder: (_, s) => s.connectionState == ConnectionState.waiting
                ? Container()
                : Expanded(
                    child: ListenableProvider.value(
                      value: customizeService.gameState.getBoardSectionState(),
                      child: ListenableProvider.value(
                        value: customizeService.gameState
                            .getBackdropSectionState(),
                        child: ListenableProvider.value(
                          value: customizeService.gameState
                              .getNameplateSectionState(),
                          child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            controller: _tabController,
                            children: [
                              // TABLE
                              Consumer<RedrawBoardSectionState>(
                                builder: (_, redrawBoardSectionState, ___) =>
                                    Container(
                                  //height: size.height * 0.3,
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 64),
                                    itemBuilder: (context, index) {
                                      final bool isSelected =
                                          (_selectedTable?.id ==
                                              _tableAssets[index].id);

                                      String previewLink =
                                          _tableAssets[index].previewLink;
                                      if (previewLink == null) {
                                        previewLink = _tableAssets[index].link;
                                      }
                                      Widget tablePreviewWidget;
                                      if (_tableAssets[index].bundled ??
                                          false) {
                                        tablePreviewWidget = Image.asset(
                                          _tableAssets[index].downloadedPath,
                                        );
                                      } else {
                                        tablePreviewWidget = CachedNetworkImage(
                                          imageUrl: previewLink,
                                          cacheManager:
                                              ImageCacheManager.instance,
                                        );
                                      }
                                      return InkResponse(
                                        onTap: () async {
                                          // _selectedTable = _tableAssets[index];

                                          // setState(() {
                                          _selectedTable = _tableAssets[index];
                                          // });

                                          redrawBoardSectionState.notify();

                                          if (!_selectedTable.downloaded) {
                                            log("Downloading ${_selectedTable.id} : ${_selectedTable.name}");
                                            _tableAssets[index] =
                                                await AssetService.saveFile(
                                              _tableAssets[index],
                                            );
                                            // Save the modified asset
                                            await AssetService.hiveStore.put(
                                              _tableAssets[index],
                                            );
                                          }

                                          // Update user settings
                                          await UserSettingsService
                                              .setSelectedTableId(
                                            _tableAssets[index],
                                          );

                                          redrawBoardSectionState.notify();
                                          // setState(() {});

                                          await customizeService
                                              .gameState.assets
                                              .initialize();

                                          customizeService.gameState
                                              .redrawBoard();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          height: size.height * 0.1,
                                          width: size.height * 0.2,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 16),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              tablePreviewWidget,
                                              Visibility(
                                                visible: isSelected,
                                                child: Icon(Icons.done),
                                              ),
                                              Visibility(
                                                visible: !(_tableAssets[index]
                                                        .downloaded ??
                                                    true),
                                                child: Container(
                                                  height: size.height * 0.1,
                                                  width: size.height * 0.2,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Icon(Icons
                                                      .download_for_offline),
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
                              ),

                              // BACKDROP
                              Consumer<RedrawBackdropSectionState>(
                                builder: (_, redrawBackdropSectionState, __) =>
                                    Container(
                                  //height: size.height * 0.3,
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 64),
                                    itemBuilder: (context, index) {
                                      final bool isSelected =
                                          (_selectedDrop?.id ==
                                              _backDropAssets[index].id);

                                      Widget backPreviewWidget;
                                      if (_backDropAssets[index].bundled ??
                                          false) {
                                        backPreviewWidget = Image.asset(
                                          _backDropAssets[index].downloadedPath,
                                        );
                                      } else {
                                        backPreviewWidget = CachedNetworkImage(
                                          cacheManager:
                                              ImageCacheManager.instance,
                                          imageUrl: _backDropAssets[index]
                                              .previewLink,
                                        );
                                      }
                                      return InkResponse(
                                        onTap: () async {
                                          // _selectedTable = _tableAssets[index];

                                          // setState(() {
                                          _selectedDrop =
                                              _backDropAssets[index];
                                          // });

                                          redrawBackdropSectionState.notify();

                                          if (!_selectedDrop.downloaded) {
                                            log("Downloading ${_selectedDrop.id} : ${_selectedDrop.name}");

                                            _backDropAssets[index] =
                                                await AssetService.saveFile(
                                              _backDropAssets[index],
                                            );

                                            await AssetService.hiveStore.put(
                                              _backDropAssets[index],
                                            );

                                            // setState(() {});
                                            redrawBackdropSectionState.notify();
                                          }

                                          // Update user settings
                                          await UserSettingsService
                                              .setSelectedBackdropId(
                                            _backDropAssets[index],
                                          );
                                          await customizeService
                                              .gameState.assets
                                              .initialize();

                                          // customizeService.gameState.redrawBoard();
                                          redrawBackdropSectionState.notify();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          height: size.height * 0.1,
                                          width: size.height * 0.2,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 16),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              backPreviewWidget,
                                              Visibility(
                                                visible: isSelected,
                                                child: Icon(Icons.done),
                                              ),
                                              Visibility(
                                                visible:
                                                    !(_backDropAssets[index]
                                                            .downloaded ??
                                                        true),
                                                child: Container(
                                                  height: size.height * 0.1,
                                                  width: size.height * 0.2,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Icon(Icons
                                                      .download_for_offline),
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
                              ),

                              // NAMEPLATE
                              Consumer<RedrawNamePlateSectionState>(
                                builder: (_, redrawNamePlateSectionState, __) =>
                                    Container(
                                  child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 190,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                    ),
                                    itemCount: _nameplateAssets.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      final bool isSelected =
                                          (_selectedNamePlate ==
                                              _nameplateAssets[index]);

                                      return InkWell(
                                        onTap: () async {
                                          _selectedNamePlate =
                                              _nameplateAssets[index];

                                          await UserSettingsService
                                              .setSelectedNameplateId(
                                            _nameplateAssets[index],
                                          );

                                          await customizeService
                                              .gameState.assets
                                              .initialize();

                                          redrawNamePlateSectionState.notify();
                                          // customizeService.gameState.redrawBoard();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: SvgPicture.string(
                                            _nameplateAssets[index].svg,
                                            width: size.width,
                                            height: size.height,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (isSelected)
                                                ? Colors.white.withOpacity(0.6)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
