
class InstaPostWithLogin {
  List<Items>? items;

  InstaPostWithLogin({this.items});

  InstaPostWithLogin.fromJson(Map<String, dynamic> json) {
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

  List<CarouselMedia>? carouselMedia;
  ImageVersions2? imageVersions2;

  Items({this.carouselMedia, this.imageVersions2});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['carousel_media'] != null) {
      carouselMedia = <CarouselMedia>[];
      json['carousel_media'].forEach((v) {
        carouselMedia!.add(CarouselMedia.fromJson(v));
      });
    }
    else {
      imageVersions2 = json['image_versions2'] != null
          ? ImageVersions2.fromJson(json['image_versions2'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (carouselMedia != null) {
      data['carousel_media'] = carouselMedia!.map((v) => v.toJson()).toList();
    }
    else {
      data['image_versions2'] = imageVersions2!.toJson();
    }
    return data;
  }
}

class CarouselMedia {
  ImageVersions2? imageVersions2;

  CarouselMedia({this.imageVersions2});

  CarouselMedia.fromJson(Map<String, dynamic> json) {
    imageVersions2 = json['image_versions2'] != null
        ? ImageVersions2.fromJson(json['image_versions2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (imageVersions2 != null) {
      data['image_versions2'] = imageVersions2!.toJson();
    }
    return data;
  }
}

class ImageVersions2 {
  List<Candidates>? candidates;

  ImageVersions2({this.candidates});

  ImageVersions2.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] != null) {
      candidates = <Candidates>[];
      json['candidates'].forEach((v) {
        candidates!.add(Candidates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (candidates != null) {
      data['candidates'] = candidates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Candidates {
  int? width;
  int? height;
  String? url;

  Candidates({this.width, this.height, this.url});

  Candidates.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['height'] = height;
    data['url'] = url;
    return data;
  }
}