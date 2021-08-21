import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:archive/archive_io.dart';

class AssetService {
  AssetService._();
  static AssetHiveStore hiveStore;
  static List<Asset> assets = [];
  static Asset defaultTableAsset;
  static Asset defaultBackdropAsset;

  static Future<void> setDefaultTableAsset({Asset asset}) async {
    await hiveStore.put(asset, id: "default-table");
    await getDefaultTableAsset();
  }

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

  static Future<void> setDefaultBackdropAsset({Asset asset}) async {
    await hiveStore.put(asset, id: "default-backdrop");
    await getDefaultBackdropAsset();
  }

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
      final destinationDir = Directory("$dir/$_filenameWithoutExtension");
      try {
        // Decode the Zip file
        final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

        // Extract the contents of the Zip archive to disk.
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('$destinationDir/' + filename)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('$destinationDir/' + filename)..create(recursive: true);
          }
        }
        // await ZipFile.extractToDirectory(
        //     zipFile: zipFile, destinationDir: destinationDir);
      } catch (e) {
        print(e);
      }
    }

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
