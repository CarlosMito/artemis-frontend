enum ImageDimensions { dim512, dim768 }

extension ParseToString on ImageDimensions {
  String toReplicateAPI() {
    String size = name.substring(3);
    return "${size}x$size";
  }
}
