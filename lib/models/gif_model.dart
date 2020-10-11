class GifModel {
  String url;

  String previewUrl;

  GifModel.fromJson(var data) {
    this.url = data['images']['downsized']['url'];
    this.previewUrl = data['images']['preview_gif']['url'];
  }
}
