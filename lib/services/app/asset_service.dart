import 'dart:convert';

import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/services/data/asset_hive_store.dart';


class AssetService {
  AssetService._();
  static AssetHiveStore hiveStore;
  static List<Asset> assets = [];

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
    for(dynamic assetJson in respBody['assets']) {
      ret.add(Asset.fromjson(assetJson));
    }
    assets = ret;
    return ret;
  }

  static List<Asset> getBackdrops() {
    List<Asset> ret = [];
    for(final asset in assets) {
      if (asset.type == 'game-background') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getCardBacks() {
    List<Asset> ret = [];
    for(final asset in assets) {
      if (asset.type == 'cardback') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getCards() {
    List<Asset> ret = [];
    for(final asset in assets) {
      if (asset.type == 'cardface') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getDials() {
    List<Asset> ret = [];
    for(final asset in assets) {
      if (asset.type == 'dial') {
        ret.add(asset);
      }
    }
    return ret;
  }

  static List<Asset> getTables() {
    List<Asset> ret = [];
    for(final asset in assets) {
      if (asset.type == 'table') {
        ret.add(asset);
      }
    }
    return ret;
  }  
}
