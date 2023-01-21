class InstaReelWithLogin {
  List<Items>? items;

  InstaReelWithLogin({this.items});

  InstaReelWithLogin.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  List<VideoVersions>? videoVersions;
  double? videoDuration;

  Items({this.videoVersions, required this.videoDuration});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['video_versions'] != null) {
      videoDuration = json['video_duration'];
      videoVersions = <VideoVersions>[];
      json['video_versions'].forEach((v) {
        videoVersions!.add(VideoVersions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (videoVersions != null) {
      data['video_versions'] = videoVersions!.map((v) => v.toJson()).toList();
      data['video_duration'] = videoDuration;
    }
    return data;
  }
}

class VideoVersions {
  int? type;
  int? width;
  int? height;
  String? url;
  String? id;

  VideoVersions({this.type, this.width, this.height, this.url, this.id});

  VideoVersions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    data['id'] = id;
    return data;
  }
}

