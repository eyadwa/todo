import 'dart:convert';

class CloudinaryResponse {
  String url;

  CloudinaryResponse(this.url);

  static CloudinaryResponse fromJson(String json) {
    var jsonObj = jsonDecode(json);
    return CloudinaryResponse(jsonObj["url"]);
  }
}