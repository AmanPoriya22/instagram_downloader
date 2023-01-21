class InstaReelWithoutLogin {
  Graphql? graphql;

  InstaReelWithoutLogin({this.graphql});

  InstaReelWithoutLogin.fromJson(Map<String, dynamic> json) {
    graphql =
        json['graphql'] != null ? Graphql.fromJson(json['graphql']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (graphql != null) {
      data['graphql'] = graphql!.toJson();
    }
    return data;
  }
}

class Graphql {
  ShortcodeMedia? shortcodeMedia;

  Graphql({this.shortcodeMedia});

  Graphql.fromJson(Map<String, dynamic> json) {
    shortcodeMedia = json['shortcode_media'] != null
        ? ShortcodeMedia.fromJson(json['shortcode_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shortcodeMedia != null) {
      data['shortcode_media'] = shortcodeMedia!.toJson();
    }
    return data;
  }
}

class ShortcodeMedia {
  String? displayUrl;
  String? videoUrl;
  double? videoDuration;

  ShortcodeMedia({this.displayUrl, this.videoUrl, this.videoDuration});

  ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
    videoDuration = json['video_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_url'] = videoUrl;
    data['video_duration'] = videoDuration;
    return data;
  }
}
