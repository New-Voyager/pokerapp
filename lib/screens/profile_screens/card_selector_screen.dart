import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:provider/provider.dart';

class CardSelectorScreen extends StatefulWidget {
  const CardSelectorScreen({Key key}) : super(key: key);

  @override
  _CardSelectorScreenState createState() => _CardSelectorScreenState();
}

class _CardSelectorScreenState extends State<CardSelectorScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Asset> _cardFaceAssets = [];
  List<Asset> _cardBackAssets = [];
  List<Asset> _betAssets = [];
  Asset _selectedCardFaceAsset, _selectedCardBackAsset, _selectedBetAsset;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchSavedItems();
    });
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void _fetchSavedItems() async {
    AssetService.assets.forEach((element) {
      log("Element Type : ${element.type}");
      if (element.type == "cardface") {
        _cardFaceAssets.add(element);
      } else if (element.type == "cardback") {
        _cardBackAssets.add(element);
      } else if (element.type == "dial") {
        _betAssets.add(element);
      }
    });
    _selectedCardFaceAsset = await AssetService.getDefaultTableAsset();
    _selectedCardBackAsset = await AssetService.getDefaultTableAsset();
    _selectedBetAsset = await AssetService.getDefaultTableAsset();
    // _selectedTable = await AssetService.getDefaultTableAsset();
    // _selectedDrop = await AssetService.getDefaultBackdropAsset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            body: Column(
              children: [
                Expanded(
                  child: _buildHeaderView(theme, size),
                ),
                /* divider that divides the board vi
                ew and the footer */
                Divider(color: theme.secondaryColor, thickness: 3),
                Container(
                  height: size.height * 0.4,
                  child: _buildHoleCardView(theme),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildHeaderView(AppTheme theme, Size size) {
    return Container(
      //height: size.height * 0.4,
      padding: EdgeInsets.only(top: 16),
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Column(
        children: [
          TabBar(
            tabs: [
              Text(
                "Card Face",
              ),
              Text(
                "Card Back",
              ),
              Text(
                "Bet",
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
                    final bool isSelected = (_selectedCardFaceAsset?.id ==
                        _cardFaceAssets[index].id);
                    return InkResponse(
                      onTap: () async {
                        // _selectedTable = _tableAssets[index];

                        setState(() {
                          _selectedCardFaceAsset = _cardFaceAssets[index];
                        });

                        if (!_selectedCardFaceAsset.downloaded) {
                          log("Downloading ${_selectedCardFaceAsset.id} : ${_selectedCardFaceAsset.name}");
                          _cardFaceAssets[index] = await AssetService.saveFile(
                              _cardFaceAssets[index]);
                          await AssetService.hiveStore
                              .put(_cardFaceAssets[index]);
                        }
                        await AssetService.setDefaultTableAsset(
                            asset: _cardFaceAssets[index]);
                        setState(() {});

                        final theme = AppTheme.getTheme(context);
                        AppThemeData data = theme.themeData;
                        data.cardFaceAssetId = _cardFaceAssets[index].id;

                        final settings = HiveDatasource.getInstance
                            .getBox(BoxType.USER_SETTINGS_BOX);
                        settings.put('theme', data.toMap());
                        settings.put('themeIndex', index);

                        theme.updateThemeData(data);

                        final asset = await AssetService.getDefaultTableAsset();
                        log(jsonEncode(asset.toJson()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: size.height * 0.2,
                        width: size.width,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: _cardFaceAssets[index].previewLink,
                              fit: BoxFit.fill,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(Icons.done),
                            ),
                            Visibility(
                              visible:
                                  !(_cardFaceAssets[index].downloaded ?? true),
                              child: Container(
                                height: size.height * 0.1,
                                width: size.width,
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
                  itemCount: _cardFaceAssets.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                ),
              ),
              Container(
                //height: size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  itemBuilder: (context, index) {
                    final bool isSelected = (_selectedCardBackAsset?.id ==
                        _cardBackAssets[index].id);
                    return InkResponse(
                      onTap: () async {
                        // _selectedTable = _tableAssets[index];

                        setState(() {
                          _selectedCardBackAsset = _cardBackAssets[index];
                        });

                        if (!_selectedCardBackAsset.downloaded) {
                          log("Downloading ${_selectedCardBackAsset.id} : ${_selectedCardBackAsset.name}");
                          _cardBackAssets[index] = await AssetService.saveFile(
                              _cardBackAssets[index]);
                          await AssetService.hiveStore
                              .put(_cardBackAssets[index]);
                        }
                        await AssetService.setDefaultTableAsset(
                            asset: _cardBackAssets[index]);
                        setState(() {});

                        final theme = AppTheme.getTheme(context);
                        AppThemeData data = theme.themeData;
                        data.cardFaceAssetId = _cardBackAssets[index].id;

                        final settings = HiveDatasource.getInstance
                            .getBox(BoxType.USER_SETTINGS_BOX);
                        settings.put('theme', data.toMap());
                        settings.put('themeIndex', index);

                        theme.updateThemeData(data);

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
                              imageUrl: _cardBackAssets[index].previewLink,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(Icons.done),
                            ),
                            Visibility(
                              visible:
                                  !(_cardBackAssets[index].downloaded ?? true),
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
                  itemCount: _cardBackAssets.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                //height: size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        (_selectedBetAsset.id == _betAssets[index].id);
                    return InkResponse(
                      onTap: () async {
                        // _selectedTable = _tableAssets[index];

                        setState(() {
                          _selectedBetAsset = _betAssets[index];
                        });

                        if (!_selectedBetAsset.downloaded) {
                          log("Downloading ${_selectedBetAsset.id} : ${_selectedBetAsset.name}");
                          _betAssets[index] =
                              await AssetService.saveFile(_betAssets[index]);
                          await AssetService.hiveStore.put(_betAssets[index]);
                        }
                        await AssetService.setDefaultTableAsset(
                            asset: _betAssets[index]);
                        setState(() {});

                        final theme = AppTheme.getTheme(context);
                        AppThemeData data = theme.themeData;
                        data.betAssetId = _betAssets[index].id;

                        final settings = HiveDatasource.getInstance
                            .getBox(BoxType.USER_SETTINGS_BOX);
                        settings.put('theme', data.toMap());
                        settings.put('themeIndex', index);

                        theme.updateThemeData(data);

                        // final asset = await AssetService.getDefaultTableAsset();
                        // log(jsonEncode(asset.toJson()));
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
                              imageUrl: _betAssets[index].previewLink,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(Icons.done),
                            ),
                            Visibility(
                              visible: !(_betAssets[index].downloaded ?? true),
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
                  itemCount: _betAssets.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  _buildHoleCardView(AppTheme theme) {
    String path = "";

    if (_tabController.index == 0) {
      path = _selectedCardFaceAsset.downloadedPath;
    } else if (_tabController.index == 1) {
      path = _selectedCardBackAsset.downloadedPath;
    } else if (_tabController.index == 2) {
      path = _selectedBetAsset.downloadedPath;
    }

    log("PATH : $path");
    return Container(
      color: Colors.amber,
      child: Image.file(
        File(path),
      ),
    );
  }
}
