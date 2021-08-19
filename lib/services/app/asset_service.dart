import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/services/data/asset_hive_store.dart';

class AssetService {
  AssetService._();
  static AssetHiveStore hiveStore;
  static List<Asset> assets = [];
  static Asset defaultTableAsset;
  static Asset defaultBackdropAsset;

  static Future<void> setDefaultTableAsset({Asset asset}) async {
    await hiveStore.put(asset, id: "default-table");
  }

  static Future<Asset> getDefaultTableAsset() async {
    if (defaultTableAsset == null) {
      // Load default asset
      hiveStore.get("default-table");
    }
    return defaultTableAsset;
  }

  static Future<void> setDefaultBackdropAsset({Asset asset}) async {
    await hiveStore.put(asset, id: "default-backdrop");
  }

  static Future<Asset> getDefaultBackdropAsset() async {
    if (defaultTableAsset == null) {
      // Load default asset
      hiveStore.get("default-backdrop");
    }
    return defaultTableAsset;
  }

  static Future<Asset> saveFile(Asset asset) async {
    Directory dir = await getApplicationDocumentsDirectory();

    final String downloadToFile =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    http.Response response = await http.get(asset.link);
    await File(downloadToFile).writeAsBytes(response.bodyBytes);
    asset.downloadedPath = downloadToFile;
    asset.downloaded = true;
    return asset;
  }

  static Future<AssetHiveStore> getStore() async {
    if (hiveStore == null) {
      hiveStore = await AssetHiveStore.openAssetStore();
    }
    return hiveStore;
  }

  static Future<List<Asset>> getAssets() async {
    String apiServerUrl = AppConfig.apiUrl;
    if (assets.length > 0) {
      return assets;
    }
    final response = await http.get(
      '$apiServerUrl/assets',
    );

    if (response.statusCode != 200) {
      return [];
    }
    final respBody = jsonDecode(response.body);
    List<Asset> ret = [];
    for (dynamic assetJson in respBody['assets']) {
      ret.add(Asset.fromjson(assetJson));
    }
    assets = ret;
    return ret;
  }

  static List<Asset> getBackdrops() {
    List<Asset> ret = [];
    for (final asset in assets) {
      if (asset.type == 'game-background') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getCardBacks() {
    List<Asset> ret = [];
    for (final asset in assets) {
      if (asset.type == 'cardback') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getCards() {
    List<Asset> ret = [];
    for (final asset in assets) {
      if (asset.type == 'cardface') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getDials() {
    List<Asset> ret = [];
    for (final asset in assets) {
      if (asset.type == 'dial') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getTables() {
    List<Asset> ret = [];
    for (final asset in assets) {
      if (asset.type == 'table') {
        ret.add(asset);
      }
    }
    return ret;
  }
}
