import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/utils/utils.dart';
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
  var customizeService = CustomizationService();

  Asset _selectedCardFaceAsset, _selectedCardBackAsset, _selectedBetAsset;
  bool isDownloading = true;
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
    await AssetService.refresh();
    _cardFaceAssets = AssetService.getCards();
    _cardBackAssets = AssetService.getCardBacks();
    _betAssets = AssetService.getDials();
    for (final asset in _betAssets) {
      if (!(asset.bundled ?? false)) {
        await AssetService.saveFile(asset);
      }
    }
    _selectedCardFaceAsset = null;
    _selectedCardBackAsset = null;
    _selectedBetAsset = null;
    customizeService.showFooterEditButton = false;
    await customizeService.load();
    isDownloading = false;
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
                  child: _buildTopView(theme, size),
                ),
                /* divider that divides the board vi
                ew and the footer */
                Divider(color: theme.secondaryColor, thickness: 3),
                Container(
                  height: size.height * 0.4,
                  child: isDownloading
                      ? CircularProgressWidget(
                          text: "Downloading...",
                        )
                      : _buildHoleCardView(theme),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildTopView(AppTheme theme, Size size) {
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
                "Bet Dial",
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
              // CardFace Widget
              _buildCardFaceWidget(theme, size),

              //Cardback widget
              _buildCardBackWidget(theme, size),

              //BetWidget
              _buildBetWidget(theme, size),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildCardFaceWidget(AppTheme theme, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      //height: size.height * 0.3,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final bool isSelected =
              (_selectedCardFaceAsset?.id == _cardFaceAssets[index].id);
          return InkResponse(
            onTap: () async {
              // _selectedTable = _tableAssets[index];

              _selectedCardFaceAsset = _cardFaceAssets[index];
              isDownloading = true;

              if (!(_selectedCardFaceAsset.bundled ?? false)) {
                if (!_selectedCardFaceAsset.downloaded) {
                  log("Downloading ${_selectedCardFaceAsset.id} : ${_selectedCardFaceAsset.name}");
                  _cardFaceAssets[index] =
                      await AssetService.saveFile(_cardFaceAssets[index]);
                  await AssetService.hiveStore.put(_cardFaceAssets[index]);
                  isDownloading = false;
                } else {
                  isDownloading = false;
                }
              } else {
                isDownloading = false;
              }
              UserSettingsStore.setSelectedCardFaceId(
                  _cardFaceAssets[index].id);

              final theme = AppTheme.getTheme(context);
              AppThemeData data = theme.themeData;
              theme.updateThemeData(data);
              await customizeService.gameState.assets.initialize();
              setState(() {
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.6)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _cardFaceAssets[index].bundled ?? false
                      ? Image.asset(_cardFaceAssets[index].previewLink,
                          fit: BoxFit.fill)
                      : CachedNetworkImage(
                          imageUrl: _cardFaceAssets[index].previewLink,
                          fit: BoxFit.fill,
                        ),
                  Visibility(
                    visible: isSelected,
                    child: Container(
                      child: Icon(Icons.done),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accentColor,
                      ),
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  Visibility(
                    visible: !(_cardFaceAssets[index].downloaded ?? true),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.15,
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
            AppDimensionsNew.getVerticalSizedBox(16),
        itemCount: _cardFaceAssets.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildCardBackWidget(AppTheme theme, Size size) {
    return Container(
      //height: size.height * 0.3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
        ),
        shrinkWrap: true,
        itemCount: _cardBackAssets.length,
        itemBuilder: (context, index) {
          final bool isSelected =
              (_selectedCardBackAsset?.id == _cardBackAssets[index].id);
          return InkResponse(
            onTap: () async {
              // _selectedTable = _tableAssets[index];

              setState(() {
                _selectedCardBackAsset = _cardBackAssets[index];
                isDownloading = true;
              });

              if (!_selectedCardBackAsset.downloaded) {
                log("Downloading ${_selectedCardBackAsset.id} : ${_selectedCardBackAsset.name}");
                _cardBackAssets[index] =
                    await AssetService.saveFile(_cardBackAssets[index]);
                await AssetService.hiveStore.put(_cardBackAssets[index]);
              }

              setState(() {
                isDownloading = false;
              });

              UserSettingsStore.setSelectedCardBackId(
                  _cardBackAssets[index].id);
              //final asset = await AssetService.getDefaultTableAsset();
              //log(jsonEncode(asset.toJson()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                    imageUrl: _cardBackAssets[index].previewLink,
                  ),
                  Visibility(
                    visible: isSelected,
                    child: Container(
                      child: Icon(Icons.done),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accentColor,
                      ),
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  Visibility(
                    visible: !(_cardBackAssets[index].downloaded ?? true),
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.2,
                      color: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.download_for_offline),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBetWidget(AppTheme theme, Size size) {
    return Container(
      //height: size.height * 0.3,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
        ),
        shrinkWrap: true,
        itemCount: _betAssets.length,
        itemBuilder: (context, index) {
          log("BETDAIL : ${_betAssets[index].previewLink}");
          final bool isSelected =
              (_selectedBetAsset?.id == _betAssets[index].id);
          return InkResponse(
            onTap: () async {
              // _selectedTable = _tableAssets[index];

              setState(() {
                _selectedBetAsset = _betAssets[index];
                isDownloading = true;
              });

              if (!_selectedBetAsset.downloaded) {
                log("Downloading ${_selectedBetAsset.id} : ${_selectedBetAsset.name}");
                _betAssets[index] =
                    await AssetService.saveFile(_betAssets[index]);
                await AssetService.hiveStore.put(_betAssets[index]);
              }
              setState(() {
                isDownloading = false;
              });

              final theme = AppTheme.getTheme(context);
              AppThemeData data = theme.themeData;
              data.betAssetId = _betAssets[index].id;

              final settings =
                  HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);
              settings.put('theme', data.toMap());
              settings.put('themeIndex', index);

              theme.updateThemeData(data);

              // final asset = await AssetService.getDefaultTableAsset();
              // log(jsonEncode(asset.toJson()));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.file(
                    File(_betAssets[index].downloadedPath),
                    allowDrawingOutsideViewBox: true,
                    placeholderBuilder: (context) => CircularProgressWidget(
                      showText: false,
                    ),
                  ),
                  Visibility(
                    visible: isSelected,
                    child: Container(
                      child: Icon(Icons.done),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accentColor,
                      ),
                      padding: EdgeInsets.all(4),
                    ),
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
      ),
    );
  }

  Widget _buildHoleCardView(AppTheme theme) {
    var gameCode = 'CUSTOMIZE';
    return GamePlayScreen(
      gameCode: gameCode,
      customizationService: customizeService,
      showTop: false,
    );
  }

  Widget _buildHoleCardView2(AppTheme theme) {
    String filePath = "";

    if (_tabController.index == 0) {
      String dirPath = _selectedCardFaceAsset?.downloadDir;
      if (dirPath == null) {
        return errorImageWidget();
      }
      log("Cards dir path : $dirPath");

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 0.67,
          crossAxisSpacing: 16,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          if (_selectedCardFaceAsset.bundled ?? false) {
            return SvgPicture.asset(
              '${_selectedCardFaceAsset.downloadedPath}/${CardConvUtils.getCardName(index)}.svg',
              fit: BoxFit.contain,
            );
          } else {
            return SvgPicture.file(
              File("$dirPath/${CardConvUtils.getCardName(index)}.svg"),
              fit: BoxFit.contain,
            );
          }
        },
        itemCount: 52,
      );
    } else if (_tabController.index == 1) {
      filePath = _selectedCardBackAsset?.downloadedPath;
      if (filePath == null) {
        return errorImageWidget();
      }
      return Container(
        child: Image.file(
          File(filePath),
        ),
      );
    } else if (_tabController.index == 2) {
      filePath = _selectedBetAsset?.downloadedPath;
      if (filePath == null) {
        return errorImageWidget();
      }
      return Container(
        child: SvgPicture.file(
          File(filePath),
        ),
      );
    }
    return errorImageWidget();
  }

  errorImageWidget() {
    return Container();
  }
}
