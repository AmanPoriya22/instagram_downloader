class InstaPostWithoutLogin {
  Graphql? graphql;

  InstaPostWithoutLogin({this.graphql});

  InstaPostWithoutLogin.fromJson(Map<String, dynamic> json) {
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
  EdgeSidecarToChildren? edgeSidecarToChildren;

  ShortcodeMedia({this.displayUrl, this.edgeSidecarToChildren});

  ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    json['edge_sidecar_to_children'] != null
        ? edgeSidecarToChildren = EdgeSidecarToChildren.fromJson(json['edge_sidecar_to_children'])
        : displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (edgeSidecarToChildren != null) {
      data['edge_sidecar_to_children'] = edgeSidecarToChildren!.toJson();
    }
    else {
      data['display_url'] = displayUrl;
    }
    return data;
  }
}

class EdgeSidecarToChildren {
  List<Edges>? edges;

  EdgeSidecarToChildren({this.edges});

  EdgeSidecarToChildren.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      edges = <Edges>[];
      json['edges'].forEach((v) {
        edges!.add(Edges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (edges != null) {
      data['edges'] = edges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Edges {
  Node? node;

  Edges({this.node});

  Edges.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (node != null) {
      data['node'] = node!.toJson();
    }
    return data;
  }
}

class Node {
  String? displayUrl;

  Node({this.displayUrl});

  Node.fromJson(Map<String, dynamic> json) {
    displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_url'] = displayUrl;
    return data;
  }
}
