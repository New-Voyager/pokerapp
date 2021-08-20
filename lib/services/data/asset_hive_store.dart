import 'dart:convert';

import 'package:hive/hive.dart';

class Asset {
  String id;
  String name;
  String link;
  String previewLink;
  String type;
  int size;
  bool defaultAsset;
  DateTime updatedDate;
  bool active;
  bool downloaded;
  String downloadDir; // directory for cards
  String downloadedPath; // file name of downloaded file (for single files)
  Asset();

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
    };
    if (updatedDate != null) {
      json["updatedDate"] = updatedDate.toIso8601String();
    }
    return jsonEncode(json);
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
    return;
  }

  Asset get(String id) {
    dynamic jsonString = _assetBox.get(id);
    if (json != null) {
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
