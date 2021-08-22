import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:archive/archive_io.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';

class AssetService {
  AssetService._();
  static AssetHiveStore hiveStore;
  static List<Asset> assets = [];
  static Asset defaultTableAsset;
  static Asset defaultBackdropAsset;

  // static Future<void> setDefaultTableAsset({Asset asset}) async {
  //   await hiveStore.put(asset, id: "default-table");
  //   await getDefaultTableAsset();
  // }

  static Future<void> refresh() async {
    try {
      final assets = await getAssets();
      hiveStore = await getStore();
      hiveStore.putAll(assets);
    } catch (err) {}
  }

  static Future<Asset> getDefaultTableAsset() async {
    try {
      defaultTableAsset = hiveStore.get("default-table");
    } catch (err) {}
    return defaultTableAsset;
  }

  // static Future<void> setDefaultBackdropAsset({Asset asset}) async {
  //   await hiveStore.put(asset, id: "default-backdrop");
  //   await getDefaultBackdropAsset();
  // }

  static Future<Asset> getDefaultBackdropAsset() async {
    try {
      defaultBackdropAsset = await hiveStore.get("default-backdrop");
    } catch (err) {}
    return defaultBackdropAsset;
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

  // static loadDefaultAssetsIntoHive() async {
  //   await loadDefaultTableAssetIntoHive();
  //   await loadDefaultAssetsIntoHive();
  // }

  // static loadDefaultTableAssetIntoHive() async {
  //   final Asset tabAsset = Asset();
  //   await putAssetIntoHive(tabAsset);
  // }

  // static loadDefaultBackdropAssetIntoHive() async {
  //   final Asset bdAsset = Asset();
  //   await putAssetIntoHive(bdAsset);
  // }

  static Asset getAssetForId(String id) {
    return hiveStore.get(id);
  }

  static setDefaultAssetsFromAssetsToFiles() async {
    if (hiveStore == null) {
      await getStore();
    }
    // Load Default table asset
    await saveDefaultTableAsset();
    // Load default backdrop asset
    await saveDefaultBackdropAsset();
  }

  static Future<void> saveDefaultTableAsset() async {
    final tableBytes = (await rootBundle.load(AppAssetsNew.defaultTablePath))
        .buffer
        .asUint8List();
    final String extension = AppAssetsNew.defaultTablePath.split(".").last;
    Directory dir = await getApplicationDocumentsDirectory();
    final file = await File("${dir.path}/defaultTable.$extension")
        .create(recursive: true);
    await file.writeAsBytes(tableBytes);
    final Asset asset = Asset(
      id: UserSettingsStore.VALUE_DEFAULT_TABLE,
      defaultAsset: true,
      downloadedPath: file.path,
      downloaded: true,
      name: "Default Table",
      link: "",
      previewLink: "",
    );

    await putAssetIntoHive(asset);
  }

  static Future<void> saveDefaultBackdropAsset() async {
    final bgdropBytes =
        (await rootBundle.load(AppAssetsNew.defaultBackdropPath))
            .buffer
            .asUint8List();
    final String extension = AppAssetsNew.defaultBackdropPath.split(".").last;
    Directory dir = await getApplicationDocumentsDirectory();
    final file = await File("${dir.path}/defaultBackdrop.$extension")
        .create(recursive: true);
    await file.writeAsBytes(bgdropBytes);
    final Asset asset = Asset(
      id: UserSettingsStore.VALUE_DEFAULT_BACKDROP,
      defaultAsset: true,
      downloadedPath: file.path,
      downloaded: true,
      name: "Default Backdrop",
      link: "",
      previewLink: "",
    );

    await putAssetIntoHive(asset);
  }
}
