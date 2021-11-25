import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class Asset {
  String id;
  String name;
  String link;
  String previewLink;
  String type;
  int size;
  bool defaultAsset = false;
  bool bundled = false;
  DateTime updatedDate;
  bool active;
  bool downloaded = false;
  String downloadDir = ''; // directory for cards
  String downloadedPath = ''; // file name of downloaded file (for single files)
  Asset({
    this.id,
    this.name,
    this.link,
    this.previewLink,
    this.type,
    this.size,
    this.defaultAsset,
    this.updatedDate,
    this.active,
    this.downloaded,
    this.downloadDir,
    this.downloadedPath,
    this.bundled,
  });

  factory Asset.fromjson(dynamic json) {
    Asset asset = Asset();
    asset.id = json['id'];
    asset.name = json['name'];
    asset.link = json['link'];
    asset.previewLink = json['previewLink'];
    if (asset.previewLink == null) {
      asset.previewLink = asset.link;
    }
    asset.type = json['type'];
    asset.size = 0;
    if (json['size'] != null) {
      asset.size = int.parse(json['size'].toString());
    }

    // if (json['updatedDate'] != null) {
    //   asset.updatedDate = DateTime.tryParse(json['updatedDate']);
    // }
    asset.downloaded = false;
    asset.downloadDir = '';
    asset.downloadedPath = '';
    if (json['downloaded'] ?? false) {
      asset.downloaded = json['downloaded'];
    }
    if (json['downloadDir'] != null) {
      asset.downloadDir = json['downloadDir'].toString();
    }
    if (json['downloadedPath'] != null) {
      asset.downloadedPath = json['downloadedPath'].toString();
    }
    if (json['bundled'] ?? false) {
      asset.bundled = json['bundled'];
    }
    return asset;
  }

  dynamic toJson() {
    Map<String, dynamic> json = {
      "id": id,
      "link": link,
      "previewLink": previewLink,
      "size": size,
      "type": type,
      "name": name,
      "downloaded": downloaded,
      "downloadDir": downloadDir,
      "downloadedPath": downloadedPath,
      "bundled": bundled,
    };
    if (updatedDate != null) {
      json["updatedDate"] = updatedDate.toIso8601String();
    }
    return jsonEncode(json);
  }

  Future<Uint8List> getBytes() async {
    if (!(this.bundled ?? false)) {
      return File(downloadedPath).readAsBytesSync();
    } else {
      try {
        final loadedAsset = await rootBundle.load(downloadedPath);
        return loadedAsset.buffer.asUint8List();
      } catch (err) {
        log('Error: ${err.toString()}, ${err.stackTrace}');
      }
    }
  }
}

class AssetHiveStore {
  Box _assetBox;

  AssetHiveStore();

  static Future<AssetHiveStore> openAssetStore() async {
    final assetStore = AssetHiveStore();
    await assetStore.open();
    return assetStore;
  }

  Future<void> put(Asset asset, {String id}) async {
    return await _assetBox.put(id ?? asset.id, asset.toJson());
  }

  Future<void> putAll(List<Asset> assets) async {
    for (final asset in assets) {
      // first get asset from the db, if it is already there, don't add it
      final assetInStore = await _assetBox.get(asset.id);
      if (assetInStore == null) {
        await _assetBox.put(asset.id, asset.toJson());
      }
    }

    // remove assets that are removed
    final assetsInStore = await getAll();
    final assetIds = assetsInStore.map((e) => e.id);
    final assetsIdsInServer = assets.map((e) => e.id).toSet();
    for (final assetId in assetIds) {
      // don't remove default assets
      if (assetId.contains("default")) {
        continue;
      }
      if (!assetsIdsInServer.contains(assetId)) {
        log('$assetId is not found in the server. Deleting the assets');
        // asset is not in the server
        // remove this asset locally
        removeAsset(assetId);
      }
    }
    return;
  }

  void removeAsset(String assetId) {
    final asset = get(assetId);
    if (asset != null) {
      try {
        if (Directory(asset.downloadDir).existsSync()) {
          Directory(asset.downloadDir).deleteSync(recursive: true);
        }
        if (File(asset.downloadedPath).existsSync()) {
          File(asset.downloadedPath).deleteSync();
        }
      } catch (err) {}
      _assetBox.delete(assetId);
    }
  }

  Future<List<Asset>> getAll() async {
    List<Asset> assetsInStore = [];
    for (final key in _assetBox.keys) {
      final asset = get(key.toString());
      if (asset != null) {
        assetsInStore.add(asset);
      }
    }
    return assetsInStore;
  }

  Asset get(String id) {
    dynamic jsonString = _assetBox.get(id);
    if (jsonString != null) {
      dynamic json = jsonDecode(jsonString);
      return Asset.fromjson(json);
    }
    return null;
  }

  Future<void> open() async {
    _assetBox = await Hive.openBox('assets');
  }

  void close() {
    if (_assetBox != null) {
      _assetBox.close();
    }
  }

  void delete() {
    if (_assetBox != null) {
      _assetBox.deleteFromDisk();
    }
  }
}
