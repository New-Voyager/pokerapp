import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:archive/archive_io.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';

class AssetService {
  AssetService._();
  static AssetHiveStore hiveStore;
  static List<Asset> assets = [];

  static Future<void> refresh() async {
    try {
      List<Asset> assets = await getAssets();
      hiveStore = await getStore();
      hiveStore.putAll(assets);
      assets = await hiveStore.getAll();
    } catch (err) {}
  }

  static Future<Asset> getDefaultTableAsset() async {
    return hiveStore.get(UserSettingsStore.KEY_SELECTED_TABLE);
  }
  // static Future<void> setDefaultBackdropAsset({Asset asset}) async {
  //   await hiveStore.put(asset, id: "default-backdrop");
  //   await getDefaultBackdropAsset();
  // }

  static Future<Asset> getDefaultBackdropAsset() async {
    return hiveStore.get(UserSettingsStore.VALUE_DEFAULT_BACKDROP);
  }

  static Future<Asset> saveFile(Asset asset) async {
    Directory dir = await getApplicationDocumentsDirectory();

    final link = asset.link;
    final String _filename = path.basename(link);
    final String _filenameWithoutExtension =
        path.basenameWithoutExtension(link);
    final String extension = path.extension(link);

    final String downloadToFile = '${dir.path}/${asset.type}_$_filename';

    log("Downloading to file : $downloadToFile");
    http.Response response = await http.get(asset.link);

    if (response.statusCode != 200) {
      return asset;
    }
    final file = await File(downloadToFile).create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);

    // Uncompression after zip is downloaded.
    if (extension == ".zip") {
      final zipFile = File(downloadToFile);

      final destinationDir =
          Directory("${dir.path}/$_filenameWithoutExtension");
      try {
        // Decode the Zip file
        final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

        // Extract the contents of the Zip archive to disk.
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('${destinationDir.path}/' + filename)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('$destinationDir/' + filename)..create(recursive: true);
          }
        }
        asset.downloadDir = destinationDir.path;
        asset.downloadedPath = downloadToFile;
        asset.downloaded = true;
      } catch (e) {
        print(e);
      }
    } else {
      asset.downloadedPath = downloadToFile;
      asset.downloaded = true;
    }

    return asset;
  }

  static Future<AssetHiveStore> getStore() async {
    if (hiveStore == null) {
      hiveStore = await AssetHiveStore.openAssetStore();
    }
    return hiveStore;
  }

  static Future<bool> exists(String id) async {
    if (hiveStore == null) {
      hiveStore = await AssetHiveStore.openAssetStore();
    }
    if (hiveStore.get(id) != null) {
      return true;
    }
    return false;
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

  static Future<void> putAssetIntoHive(Asset asset, {String id}) async {
    if (asset != null) {
      await hiveStore.put(asset, id: id ?? asset.id);
    }
  }

  static Future<void> putAsset(Asset asset, {String id}) async {
    if (asset != null) {
      await hiveStore.put(asset, id: id ?? asset.id);
    }
  }

  static Asset getAssetForId(String id) {
    return hiveStore.get(id);
  }

  static updateBundledAssets() async {
    if (hiveStore == null) {
      await getStore();
    }

    await UserSettingsStore.openSettingsStore();
    // default assets
    // assets/images/default/cardface
    // assets/images/default/backdrop.png
    // assets/images/default/betdial.svg
    // assets/images/default/cardback.png
    // assets/images/default/table.png
    if (!await AssetService.exists(UserSettingsStore.VALUE_DEFAULT_CARDFACE)) {
      Asset asset = Asset(
          id: UserSettingsStore.VALUE_DEFAULT_CARDFACE,
          defaultAsset: true,
          downloadedPath: 'assets/images/default/cardface',
          downloadDir: 'assets/images/default/cardface',
          downloaded: true,
          name: "Default Card Face",
          link: "",
          previewLink: "assets/images/default/cardface/preview.png",
          bundled: true,
          type: 'cardface');
      await AssetService.putAsset(asset);
    }

    if (!await AssetService.exists(UserSettingsStore.VALUE_DEFAULT_TABLE)) {
      Asset asset = Asset(
          id: UserSettingsStore.VALUE_DEFAULT_TABLE,
          defaultAsset: true,
          downloadedPath: 'assets/images/default/table.png',
          downloaded: true,
          name: "Default Table",
          link: "",
          bundled: true,
          type: "table");
      await AssetService.putAsset(asset);
    }

    if (!await AssetService.exists(UserSettingsStore.VALUE_DEFAULT_BACKDROP)) {
      Asset asset = Asset(
          id: UserSettingsStore.VALUE_DEFAULT_BACKDROP,
          defaultAsset: true,
          downloadedPath: 'assets/images/default/backdrop.png',
          downloaded: true,
          name: "Default Backdrop",
          link: "",
          bundled: true,
          type: "game-background");
      await AssetService.putAsset(asset);
    }

    if (!await AssetService.exists(UserSettingsStore.VALUE_DEFAULT_CARDBACK)) {
      Asset asset = Asset(
          id: UserSettingsStore.VALUE_DEFAULT_CARDBACK,
          defaultAsset: true,
          downloadedPath: 'assets/images/default/cardback.png',
          downloaded: true,
          name: "Default Card Back",
          link: "",
          bundled: true,
          type: "cardback");
      await AssetService.putAsset(asset);
    }

    if (!await AssetService.exists(UserSettingsStore.VALUE_DEFAULT_BETDIAL)) {
      Asset asset = Asset(
          id: UserSettingsStore.VALUE_DEFAULT_BETDIAL,
          defaultAsset: true,
          downloadedPath: 'assets/images/default/betdial.svg',
          downloaded: true,
          name: "Default Bet Dial",
          link: "",
          bundled: true,
          type: "dial");
      await AssetService.putAsset(asset);
    }
  }
}
